Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab0DVU1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:27:25 -0400
Received: from kroah.org ([198.145.64.141]:59567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab0DVUAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:00 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:08 2010
Message-Id: <20100422195408.040337000@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
       Stefani Seibold <stefani@seibold.net>
Subject: [033/139] include/linux/kfifo.h: fix INIT_KFIFO()
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Härdeman <david@hardeman.nu>

commit 530cd330dc3865e3107304a6e84fdc332aa72f7d upstream.

DECLARE_KFIFO creates a union with a struct kfifo and a buffer array with
size [size + sizeof(struct kfifo)].

INIT_KFIFO then sets the buffer pointer in struct kfifo to point to the
beginning of the buffer array which means that the first call to kfifo_in
will overwrite members of the struct kfifo.

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index ece0b1c..e117b1a 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -86,7 +86,8 @@ union { \
  */
 #define INIT_KFIFO(name) \
 	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
-				sizeof(struct kfifo), name##kfifo_buffer)
+				sizeof(struct kfifo), \
+				name##kfifo_buffer + sizeof(struct kfifo))
 
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo


