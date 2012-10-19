Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2JSCxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:53:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:52571 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965062Ab2JSCte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabio Porcedda <fabio.porcedda@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 67/76] usb: gadget: at91_udc: fix dt support
Date: Thu, 18 Oct 2012 19:47:31 -0700
Message-Id: <20121019024400.903613316@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 9c6d196d5aa35e07482f23c3e37755e7a82140e0 upstream.

Don't fail the initialization check for the platform_data
if there is avaiable an associated device tree node.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/at91_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1699,7 +1699,7 @@ static int __devinit at91udc_probe(struc
 	int		retval;
 	struct resource	*res;
 
-	if (!dev->platform_data) {
+	if (!dev->platform_data && !pdev->dev.of_node) {
 		/* small (so we copy it) but critical! */
 		DBG("missing platform_data\n");
 		return -ENODEV;


