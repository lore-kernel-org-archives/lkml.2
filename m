Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1GPPmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 11:42:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28894 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1GPPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 11:42:08 -0400
Date: Sat, 16 Jul 2011 17:42:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mutex: Make mutex_destroy an inline function
Message-ID: <20110716174200.41002352@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-debug variant of mutex_destroy is a no-op, currently
implemented as a macro which does nothing. This approach fails to
check the type of the parameter, so an error would only show when
debugging gets enabled. Using an inline function instead, offers
type checking for earlier bug catching.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mutex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.0-rc7.orig/include/linux/mutex.h	2011-05-30 20:45:24.000000000 +0200
+++ linux-3.0-rc7/include/linux/mutex.h	2011-07-16 15:42:38.000000000 +0200
@@ -92,7 +92,7 @@ do {							\
 							\
 	__mutex_init((mutex), #mutex, &__key);		\
 } while (0)
-# define mutex_destroy(mutex)				do { } while (0)
+static inline void mutex_destroy(struct mutex *lock) {}
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC


-- 
Jean Delvare
