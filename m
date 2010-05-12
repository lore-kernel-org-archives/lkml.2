Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0ELM5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:57:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52726 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0ELM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mq5ih210EJ3fJ/9/PxgPVwjl2u667iVmOY6RE4YxIdvJdWdgzlOfAR/fzlN6HCw95Q
         7MEXSAQ1wv3iL5hAdzzDFJ9b5Yc5eR/yNmEqW6kvcLzbFXuvvy27tQcmZDQRfCIRjgJZ
         o6nkVn1wcVvPPy5YGNJAXqtrceRtI1yPh7PWo=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] remove bogus #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT for debug_kmap_atomic()
Date: Wed, 12 May 2010 21:57:01 +0900
Message-Id: <1273669021-528-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f4112de6b679d84bd9b9681c7504be7bdfb7c7d5 I said that debug_kmap_atomic()
needs CONFIG_TRACE_IRQFLAGS_SUPPORT.

It was wrong. (I thought irqs_disabled() is only available when
the architecture has CONFIG_TRACE_IRQFLAGS_SUPPORT)

Remove the #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT check to enable
kmap_atomic() debugging for the architectures which do not have
CONFIG_TRACE_IRQFLAGS_SUPPORT.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/highmem.h |    2 +-
 mm/highmem.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 74152c0..caafd05 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -27,7 +27,7 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 
 #include <asm/kmap_types.h>
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+#ifdef CONFIG_DEBUG_HIGHMEM
 
 void debug_kmap_atomic(enum km_type type);
 
diff --git a/mm/highmem.c b/mm/highmem.c
index bed8a8b..66baa20 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -422,7 +422,7 @@ void __init page_address_init(void)
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+#ifdef CONFIG_DEBUG_HIGHMEM
 
 void debug_kmap_atomic(enum km_type type)
 {
-- 
1.6.0.6

