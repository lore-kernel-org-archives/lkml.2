Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1CFPqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 10:46:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63200 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1CFPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 10:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=ZKtKHR4w4KpAGCkdYKjH6lrvu4oFtaO9vwQWATHAU+VNTmP6SFQeM2rXk1gENX5csk
         /X/yWz/O6dAIA4rcnXgAPIJf0W+wQHwBll561oOk0jPmZbHSoTWh0kRaVJ7EcpbJpQkB
         mV8iKWrJZueh0u6ag1XmfI+6xaa/ZT1F4gEW4=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [ARM] tlb: fix build error with CONFIG_SWAP=n
Date: Sun,  6 Mar 2011 18:46:26 +0300
Message-Id: <1299426386-28746-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error with CONFIG_SWAP=n:

In file included from arch/arm/mm/init.c:28:
arch/arm/include/asm/tlb.h: In function ‘tlb_flush_mmu’:
arch/arm/include/asm/tlb.h:104: error: implicit declaration of function ‘release_pages’
arch/arm/include/asm/tlb.h: In function ‘tlb_remove_page’:
arch/arm/include/asm/tlb.h:168: error: implicit declaration of function ‘page_cache_release’

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/include/asm/tlb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index 82dfe5d..36e75e5 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -29,6 +29,7 @@
 
 #else /* !CONFIG_MMU */
 
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
-- 
1.7.2.3

