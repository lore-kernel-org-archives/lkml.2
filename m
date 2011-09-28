Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1I1Wim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab1I1Wij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:29 2011
Message-Id: <20110928220129.374211200@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikael Pettersson <mikpe@it.uu.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [039/244] sparc64: remove unnecessary macros from spinlock_64.h
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

commit a0fba3eb059e73fed2d376a901f8117734c12f1f upstream.

The sparc64 spinlock_64.h contains a number of operations defined
first as static inline functions, and then as macros with the same
names and parameters as the functions.  Maybe this was needed at
some point in the past, but now nothing seems to depend on these
macros (checked with a recursive grep looking for ifdefs on these
names).  Other archs don't define these identity-macros.

So this patch deletes these unnecessary macros.

Compile-tested with sparc64_defconfig.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/spinlock_64.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
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


