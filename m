Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2DRUx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:53:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:35898 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2DRUx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:53:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH] xtensa: fix build error in xtensa/include/asm/io.h
Date: Wed, 18 Apr 2012 16:53:11 -0400
Message-Id: <1334782391-468-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caused by commit 6c03438edeb5c359af35f060ea016ca65671c269

    kernel.h: doesn't explicitly use bug.h, so don't include it.

This header uses bug.h so explicitly include it now that the
implicit presence was removed by 6c03438ed.

Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index d04cd3a..4beb43c 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -14,6 +14,7 @@
 #ifdef __KERNEL__
 #include <asm/byteorder.h>
 #include <asm/page.h>
+#include <linux/bug.h>
 #include <linux/kernel.h>
 
 #include <linux/types.h>
-- 
1.7.9.1

