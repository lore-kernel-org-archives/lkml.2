Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883Ab3AIVM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:12:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:42935 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685Ab3AIUjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Afzal Mohammed <afzal@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 063/123] Revert "usb: musb: dsps: remove explicit NOP device creation"
Date: Wed,  9 Jan 2013 12:35:02 -0800
Message-Id: <20130109201506.691500886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Afzal Mohammed <afzal@ti.com>

commit d75542263a0b005876d112bbf9ffb23180cc3149 upstream.

This reverts commit d8c3ef256f88b7c6ecd673d03073b5645be9c5e4.

Above mentioned change was made along with multi usb phy change and
adding DT support for nop transceiver. But other two changes did not
make it to mainline. This in effect makes dsps musb wrapper unusable
even for single instance.

Hence revert it so that at least single instance can be supported.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_dsps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -377,7 +377,8 @@ static int dsps_musb_init(struct musb *m
 	/* mentor core register starts at offset of 0x400 from musb base */
 	musb->mregs += wrp->musb_core_offset;
 
-	/* Get the NOP PHY */
+	/* NOP driver needs change if supporting dual instance */
+	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -ENODEV;


