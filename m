Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0LHCGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:06:40 -0500
Received: from kroah.org ([198.145.64.141]:58425 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab0LHArb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:31 2010
Message-Id: <20101208004431.092077960@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        Kees Cook <kees.cook@canonical.com>
Subject: [068/127] usb: misc: iowarrior: fix information leak to userland
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -552,6 +552,7 @@ static long iowarrior_ioctl(struct file
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;


