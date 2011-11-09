Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068Ab1KJD3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935056Ab1KJD3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.595864553@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [169/262] USB: Avoid NULL pointer deref in usb_hcd_alloc_bandwidth.
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 8a9af4fdf6d5eeb3200a088354d266a87e8260b0 upstream.

usb_ifnum_to_if() can return NULL if the USB device does not have a
configuration installed (usb_device->actconfig == NULL), or if we can't
find the interface number in the installed configuration.  Return an
error instead of crashing.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1764,6 +1764,8 @@ int usb_hcd_alloc_bandwidth(struct usb_d
 		struct usb_interface *iface = usb_ifnum_to_if(udev,
 				cur_alt->desc.bInterfaceNumber);
 
+		if (!iface)
+			return -EINVAL;
 		if (iface->resetting_device) {
 			/*
 			 * The USB core just reset the device, so the xHCI host


