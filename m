Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab1FRACQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab1FRACP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:02:15 -0400
Date: Fri, 17 Jun 2011 20:02:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Subject: Remove over-broad module alias from zaurus.
Message-ID: <20110618000210.GA8639@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module and a bunch of dependancies are getting loaded on several
of laptops I have (probably picking up the mobile broadband device),
that have nothing to do with zaurus. Matching by class without
any vendor/device pair isn't the right thing to do here, as it
will prevent any other driver from correctly binding to it.
(Or in the absense of a driver, will just waste time & memory by
 unnecessarily loading modules)

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
index 241756e..1a2234c 100644
--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -331,17 +331,7 @@ static const struct usb_device_id	products [] = {
 	ZAURUS_MASTER_INTERFACE,
 	.driver_info = ZAURUS_PXA_INFO,
 },
-
-
-/* At least some of the newest PXA units have very different lies about
- * their standards support:  they claim to be cell phones offering
- * direct access to their radios!  (No, they don't conform to CDC MDLM.)
- */
 {
-	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MDLM,
-			USB_CDC_PROTO_NONE),
-	.driver_info = (unsigned long) &bogus_mdlm_info,
-}, {
 	/* Motorola MOTOMAGX phones */
 	USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
