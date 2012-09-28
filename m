Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659Ab2I1UmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:42:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33602 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759586Ab2I1UlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:41:14 -0400
X-Sasl-enc: KJlsfg4cstfb2NgFH0u7Dro8PDUKzpaEbo2Cr/i4HeQs 1348864873
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Fengguang Wu <fengguang.wu@intel.com>,
        Michael Cree <mcree@orcon.net.nz>, Matt Turner <mattst88@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 042/127] Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
Date: Fri, 28 Sep 2012 13:33:35 -0700
Message-Id: <20120928203050.791259697@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 67a806d9499353fabd5b5ff07337f3aa88a1c3ba upstream.

The following build error occurred during an alpha build:

  net/core/sock.c:274:36: error: initializer element is not constant

Dave Anglin says:
> Here is the line in sock.i:
>
> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> ((atomic_t) { (0) }) });

The above line contains two compound literals.  It also uses a designated
initializer to initialize the field enabled.  A compound literal is not a
constant expression.

The location of the above statement isn't fully clear, but if a compound
literal occurs outside the body of a function, the initializer list must
consist of constant expressions.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -14,8 +14,8 @@
  */
 
 
-#define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
-#define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
+#define ATOMIC_INIT(i)		{ (i) }
+#define ATOMIC64_INIT(i)	{ (i) }
 
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic64_read(v)	(*(volatile long *)&(v)->counter)


