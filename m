Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0LMAC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:02:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36455 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0LLXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: segooon@gmail.com, kees.cook@canonical.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [151/223] usb: misc: iowarrior: fix information leak to userland
Message-Id: <20101212234734.823E1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segooon@gmail.com>

commit eca67aaeebd6e5d22b0d991af1dd0424dc703bfb upstream.

Structure iowarrior_info is copied to userland with padding byted
between "serial" and "revision" fields uninitialized.  It leads to
leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/iowarrior.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/usb/misc/iowarrior.c
===================================================================
--- linux.orig/drivers/usb/misc/iowarrior.c
+++ linux/drivers/usb/misc/iowarrior.c
@@ -552,6 +552,7 @@ static long iowarrior_ioctl(struct file
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;
