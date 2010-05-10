Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0EJXEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:04:48 -0400
Received: from kroah.org ([198.145.64.141]:45391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943Ab0EJW6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:42 2010
Message-Id: <20100510223541.959402628@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stijn Tintel <stijn@linux-ipv6.be>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [84/98] virtio: initialize earlier
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stijn Tintel <stijn@linux-ipv6.be>

commit e2dbe06c271f3bb2a495627980aad3d1d8ccef2a upstream.

Move initialization of the virtio framework before the initialization of
mtd, so that block2mtd can be used on virtio-based block devices.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15644

Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SFI)		+= sfi/
 obj-$(CONFIG_PNP)		+= pnp/
 obj-$(CONFIG_ARM_AMBA)		+= amba/
 
+obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
 
 # regulators early, since some subsystems rely on them to initialize
@@ -106,7 +107,6 @@ obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
-obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/


