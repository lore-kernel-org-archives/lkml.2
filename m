Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0LHAkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:40:21 -0500
Received: from kroah.org ([198.145.64.141]:54775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab0LHAea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:30 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:41 2010
Message-Id: <20101208000641.228540431@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        Kees Cook <kees.cook@canonical.com>
Subject: [17/44] usb: misc: iowarrior: fix information leak to userland
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit eca67aaeebd6e5d22b0d991af1dd0424dc703bfb upstream.

Structure iowarrior_info is copied to userland with padding byted
between "serial" and "revision" fields uninitialized.  It leads to
leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/iowarrior.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -551,6 +551,7 @@ static long iowarrior_ioctl(struct file
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;


