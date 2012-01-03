Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2ACSpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:45:10 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52218 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2ACSpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:45:08 -0500
From: Simon Glass <sjg@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olofj@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Simon Glass <sjg@chromium.org>
Subject: [PATCH] ARM: Remove BUILD_BUG_ON from asm/bug.h
Date: Tue,  3 Jan 2012 10:44:36 -0800
Message-Id: <1325616276-10304-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON is defined in linux/kernel.h but that is not included by the
asm/bug.h header which uses it. This causes a build error:

...include/linux/mtd/map.h: In function 'inline_map_read':
...include/linux/mtd/map.h:408:3: error: implicit declaration of function
'BUILD_BUG_ON' [-Werror=implicit-function-declaration]

The check is not essential and is not present for other architectures, so
just remove it.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/include/asm/bug.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
index 9abe7a0..fac79dc 100644
--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -32,7 +32,6 @@
 
 #define __BUG(__file, __line, __value)				\
 do {								\
-	BUILD_BUG_ON(sizeof(struct bug_entry) != 12);		\
 	asm volatile("1:\t" BUG_INSTR_TYPE #__value "\n"	\
 		".pushsection .rodata.str, \"aMS\", %progbits, 1\n" \
 		"2:\t.asciz " #__file "\n" 			\
-- 
1.7.3.1

