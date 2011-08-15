Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1HOUKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:10:36 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:61633 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1HOUKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:10:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20041.32055.652850.148995@pilspetsen.it.uu.se>
Date: Mon, 15 Aug 2011 22:10:31 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: sparclinux@vger.kernel.org
Subject: [PATCH] sparc64: remove unnecessary macros from spinlock_64.h
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparc64 spinlock_64.h contains a number of operations defined
first as static inline functions, and then as macros with the same
names and parameters as the functions.  Maybe this was needed at
some point in the past, but now nothing seems to depend on these
macros (checked with a recursive grep looking for ifdefs on these
names).  Other archs don't define these identity-macros.

So this patch deletes these unnecessary macros.

Compile-tested with sparc64_defconfig.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
--- linux-3.1-rc2/arch/sparc/include/asm/spinlock_64.h.~1~	2011-05-19 06:06:34.000000000 +0200
+++ linux-3.1-rc2/arch/sparc/include/asm/spinlock_64.h	2011-08-15 20:51:27.000000000 +0200
@@ -210,14 +210,8 @@ static int inline arch_write_trylock(arc
 	return result;
 }
 
-#define arch_read_lock(p)	arch_read_lock(p)
 #define arch_read_lock_flags(p, f) arch_read_lock(p)
-#define arch_read_trylock(p)	arch_read_trylock(p)
-#define arch_read_unlock(p)	arch_read_unlock(p)
-#define arch_write_lock(p)	arch_write_lock(p)
 #define arch_write_lock_flags(p, f) arch_write_lock(p)
-#define arch_write_unlock(p)	arch_write_unlock(p)
-#define arch_write_trylock(p)	arch_write_trylock(p)
 
 #define arch_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
 #define arch_write_can_lock(rw)	(!(rw)->lock)
