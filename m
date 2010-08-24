Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab0HXXoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:44:05 -0400
Received: from kroah.org ([198.145.64.141]:52220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab0HXWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:05 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:25 2010
Message-Id: <20100824222525.261588606@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [33/59] sparc64: Fix atomic64_t routine return values.
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commits 86fa04b8742ac681d470786f55e2403ada0075b2
  and b10f997bb0f4e5b34d447f498fb85834a40d3acb ]

Should return 'long' instead of 'int'.

Thanks to Dimitris Michailidis and Tony Luck.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/atomic_64.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -20,14 +20,14 @@
 #define atomic64_set(v, i)	(((v)->counter) = i)
 
 extern void atomic_add(int, atomic_t *);
-extern void atomic64_add(int, atomic64_t *);
+extern void atomic64_add(long, atomic64_t *);
 extern void atomic_sub(int, atomic_t *);
-extern void atomic64_sub(int, atomic64_t *);
+extern void atomic64_sub(long, atomic64_t *);
 
 extern int atomic_add_ret(int, atomic_t *);
-extern int atomic64_add_ret(int, atomic64_t *);
+extern long atomic64_add_ret(long, atomic64_t *);
 extern int atomic_sub_ret(int, atomic_t *);
-extern int atomic64_sub_ret(int, atomic64_t *);
+extern long atomic64_sub_ret(long, atomic64_t *);
 
 #define atomic_dec_return(v) atomic_sub_ret(1, v)
 #define atomic64_dec_return(v) atomic64_sub_ret(1, v)
@@ -91,7 +91,7 @@ static inline int atomic_add_unless(atom
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
+static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 {
 	long c, old;
 	c = atomic64_read(v);


