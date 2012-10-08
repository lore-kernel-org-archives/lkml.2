Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2JHCGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 22:06:19 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35133 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2JHCGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 22:06:16 -0400
X-Originating-IP: 217.70.178.149
X-Originating-IP: 50.43.39.152
Date: Sun, 7 Oct 2012 19:06:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Cc: Ed Cashin <ecashin@coraid.com>, Christopher Li <sparse@chrisli.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] linux/compiler.h: Add __must_hold macro for functions called
 with a lock held
Message-ID: <20121008020610.GA9197@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/compiler.h has macros to denote functions that acquire or release
locks, but not to denote functions called with a lock held that return
with the lock still held.  Add a __must_hold macro to cover that case.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Ed Cashin <ecashin@coraid.com>
Tested-by: Ed Cashin <ecashin@coraid.com>
---
 include/linux/compiler.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f430e41..b121554 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -10,6 +10,7 @@
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
 # define __iomem	__attribute__((noderef, address_space(2)))
+# define __must_hold(x)	__attribute__((context(x,1,1)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
@@ -33,6 +34,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __chk_user_ptr(x) (void)0
 # define __chk_io_ptr(x) (void)0
 # define __builtin_warning(x, y...) (1)
+# define __must_hold(x)
 # define __acquires(x)
 # define __releases(x)
 # define __acquire(x) (void)0
-- 
1.7.10.4

