Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0JEP5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:57:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53601 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0JEP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mHJup+eM+nGFzn1QicUNU6A7okxqv6ruy6BpuVmKP/IkMH+7TZSmooTzh4AEgEh+u1
         zw2O0A4uS/Ep9MPj1wzonjuAVcN3w5YPZ+IwdeRv73UItrzoarQx7Tw8WQd9wlm9cxTx
         6Cw8wK8FFlLgk3GVRZwIdx5aZPy5EOQ6BikS4=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] tile: replace some BUG_ON checks with BUILD_BUG_ON checks
Date: Wed,  6 Oct 2010 00:55:29 +0900
Message-Id: <1286294129-6205-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BUG_ON checks can be detected at compile time rather than
at runtime.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---

This patch is not compile tested.

 arch/tile/lib/atomic_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 8040b42..7a5cc70 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -300,7 +300,7 @@ void __init __init_atomic_per_cpu(void)
 #else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 
 	/* Validate power-of-two and "bigger than cpus" assumption */
-	BUG_ON(ATOMIC_HASH_SIZE & (ATOMIC_HASH_SIZE-1));
+	BUILD_BUG_ON(ATOMIC_HASH_SIZE & (ATOMIC_HASH_SIZE-1));
 	BUG_ON(ATOMIC_HASH_SIZE < nr_cpu_ids);
 
 	/*
@@ -314,17 +314,17 @@ void __init __init_atomic_per_cpu(void)
 	BUG_ON((unsigned long)atomic_locks % PAGE_SIZE != 0);
 
 	/* The locks must all fit on one page. */
-	BUG_ON(ATOMIC_HASH_SIZE * sizeof(int) > PAGE_SIZE);
+	BUILD_BUG_ON(ATOMIC_HASH_SIZE * sizeof(int) > PAGE_SIZE);
 
 	/*
 	 * We use the page offset of the atomic value's address as
 	 * an index into atomic_locks, excluding the low 3 bits.
 	 * That should not produce more indices than ATOMIC_HASH_SIZE.
 	 */
-	BUG_ON((PAGE_SIZE >> 3) > ATOMIC_HASH_SIZE);
+	BUILD_BUG_ON((PAGE_SIZE >> 3) > ATOMIC_HASH_SIZE);
 
 #endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 
 	/* The futex code makes this assumption, so we validate it here. */
-	BUG_ON(sizeof(atomic_t) != sizeof(int));
+	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(int));
 }
-- 
1.6.0.6

