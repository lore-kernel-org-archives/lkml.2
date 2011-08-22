Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1HVPhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:37:04 -0400
Received: from mail-pz0-f66.google.com ([209.85.210.66]:37185 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1HVPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:37:00 -0400
MIME-Version: 1.0
Date: Mon, 22 Aug 2011 21:06:59 +0530
Message-ID: <CA+OjSzww54ogPKD4PuKR6=37fbTBwnWq5yw2NSTZM0pH1N8S1g@mail.gmail.com>
Subject: [PATCH] xhci: Redundant check for xhci->devs[]
From: sifram rajas <sifram.rajas@gmail.com>
To: sarah.a.sharp@intel.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

This patch is for linux-3.0.3.

In the xhci_check_args() function in xhci.c, there is a redundant
check for xhci->devs.

This is redundant because the struct xhci_hcd->devs is actually
defined as a static array
of pointers and is not a pointer to a pointer.

Signed-off-by: Sifram Rajas <sifram.rajas@gmail.com>
---
drivers/usb/host/xhci.c |   3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
--- a/drivers/usb/host/xhci.c   2011-08-17 23:27:16.000000000 +0530
+++ b/drivers/usb/host/xhci.c   2011-08-22 20:43:34.250000000 +0530
@@ -945,8 +945,7 @@ static int xhci_check_args(struct usb_hc
               return -ENODEV;

       if (check_virt_dev) {
-               if (!udev->slot_id || !xhci->devs
-                       || !xhci->devs[udev->slot_id]) {
+               if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
                       printk(KERN_DEBUG "xHCI %s called with unaddressed "
                                               "device\n", func);
                       return -EINVAL;

Thanks,
Sifram Rajas.
