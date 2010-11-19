Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0KSWbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:31:03 -0500
Received: from kroah.org ([198.145.64.141]:45063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab0KSV6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:36 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:41 2010
Message-Id: <20101119215640.977604850@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [27/82] p54usb: fix off-by-one on !CONFIG_PM
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 11791a6f7534906b4a01ffb54ba0b02ca39398ef upstream.

The ISL3887 chip needs a USB reset, whenever the
usb-frontend module "p54usb" is reloaded.

This patch fixes an off-by-one bug, if the user
is running a kernel without the CONFIG_PM option
set and for some reason (e.g.: compat-wireless)
wants to switch between different p54usb modules.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -930,8 +930,8 @@ static int __devinit p54u_probe(struct u
 #ifdef CONFIG_PM
 		/* ISL3887 needs a full reset on resume */
 		udev->reset_resume = 1;
+#endif /* CONFIG_PM */
 		err = p54u_device_reset(dev);
-#endif
 
 		priv->hw_type = P54U_3887;
 		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);


