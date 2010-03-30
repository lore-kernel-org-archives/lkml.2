Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0C3Xjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:39:49 -0400
Received: from kroah.org ([198.145.64.141]:46303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab0C3XUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:41 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:15 2010
Message-Id: <20100330224815.206858923@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
       Stefani Seibold <stefani@seibold.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [084/156] kfifo: fix KFIFO_INIT in include/linux/kfifo.h
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>

commit 4c87684d32e8f95715d53039dcd2d998dc63d1eb upstream.

include/linux/kfifo.h first defines and then undefines __kfifo_initializer
which is used by INIT_KFIFO (which is also a macro, so building a module
which uses INIT_KFIFO will fail).

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kfifo.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -102,8 +102,6 @@ union { \
 	unsigned char name##kfifo_buffer[size]; \
 	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
 
-#undef __kfifo_initializer
-
 extern void kfifo_init(struct kfifo *fifo, void *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,


