Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2ILXiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:38:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab2ILXhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:37:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Michael Cree <mcree@orcon.net.nz>,
        Matt Turner <mattst88@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 20/85] alpha: Dont export SOCK_NONBLOCK to user space.
Date: Wed, 12 Sep 2012 16:36:03 -0700
Message-Id: <20120912233543.845388142@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/include/asm/socket.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/alpha/include/asm/socket.h
+++ b/arch/alpha/include/asm/socket.h
@@ -76,9 +76,11 @@
 /* Instruct lower device to use last 4-bytes of skb data as FCS */
 #define SO_NOFCS		43
 
+#ifdef __KERNEL__
 /* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
  * have to define SOCK_NONBLOCK to a different value here.
  */
 #define SOCK_NONBLOCK	0x40000000
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_SOCKET_H */


