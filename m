Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0IGO2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:28:15 -0400
Received: from forward7.mail.yandex.net ([77.88.61.37]:39342 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0IGO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:28:07 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 10:28:06 EDT
X-Yandex-Spam: 0
X-Yandex-Front: web92.yandex.ru 
X-Yandex-TimeMark: 1283869328 
From: Tkhai Kirill <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH]RT-Patch: Fixed sparc's anon_rwsem_is_locked() and page_address_init() define
MIME-Version: 1.0
Message-Id: <7791283869327@web92.yandex.ru>
Date: Tue, 07 Sep 2010 18:22:07 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RT-Patch: Fixed sparc's anon_rwsem_is_locked() and page_address_init() define
Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
---

Fixed compilation errors. Kernel version 2.6.33.7-rt29.

diff -uprN a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
--- a/arch/sparc/include/asm/rwsem.h	2010-09-07 17:44:51.727914479 +0400
+++ b/arch/sparc/include/asm/rwsem.h	2010-09-07 17:35:40.423917446 +0400
@@ -75,7 +75,7 @@ static inline void rwsem_atomic_add(int 
 	atomic_add(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int anon_rwsem_is_locked(struct rw_semaphore *sem)
+static inline int anon_rwsem_is_locked(struct rw_anon_semaphore *sem)
 {
 	return (sem->count != 0);
 }
diff -uprN a/mm/highmem.c b/mm/highmem.c
--- a/mm/highmem.c	2010-09-07 17:44:58.003917532 +0400
+++ b/mm/highmem.c	2010-09-07 17:39:43.970912094 +0400
@@ -590,7 +590,7 @@ static int __set_page_address(struct pag
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
 
-#if defined(CONFIG_HIGHMEM) || defined(HASHED_PAGE_VIRTUAL)
+#if defined(WANT_PAGE_VIRTUAL) || defined(HASHED_PAGE_VIRTUAL)
 
 void __init page_address_init(void)
 {
