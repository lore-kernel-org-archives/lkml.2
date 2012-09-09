Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2IIXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51384 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171Ab2IIXQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:49 -0400
Message-Id: <20120909224157.763994104@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Cree <mcree@orcon.net.nz>,
        Matt Turner <mattst88@gmail.com>
Subject: [ 51/95] alpha: Dont export SOCK_NONBLOCK to user space.
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Cree <mcree@orcon.net.nz>

commit a2fa3ccd7b43665fe14cb562761a6c3d26a1d13f upstream.

Currently we export SOCK_NONBLOCK to user space but that conflicts with
the definition from glibc leading to compilation errors in user programs
(e.g.  see Debian bug #658460).

The generic socket.h restricts the definition of SOCK_NONBLOCK to the
kernel, as does the MIPS specific socket.h, so let's do the same on
Alpha.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/alpha/include/asm/socket.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/alpha/include/asm/socket.h
+++ b/arch/alpha/include/asm/socket.h
@@ -69,9 +69,11 @@
 
 #define SO_RXQ_OVFL             40
 
+#ifdef __KERNEL__
 /* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
  * have to define SOCK_NONBLOCK to a different value here.
  */
 #define SOCK_NONBLOCK	0x40000000
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_SOCKET_H */


