Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab1C3Vl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:41:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:24256 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569Ab1C3VIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735425"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mhej@o2.pl, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [143/275] USB: Add quirk for Samsung Android phone modem
Message-Id: <20110330210624.451AB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Maciej Szmigiero <mhej@o2.pl>

commit 72a012ce0a02c6c616676a24b40ff81d1aaeafda upstream.

My Galaxy Spica needs this quirk when in modem mode, otherwise
it causes endless USB bus resets and is unusable in this mode.

Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
for the modem part.
That's why in addition to this patch the visor driver must be prevented
from binding to SPH-I500 ID, so ACM driver can do that.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/drivers/usb/core/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/quirks.c	2011-03-29 23:03:01.209269229 -0700
+++ linux-2.6.35.y/drivers/usb/core/quirks.c	2011-03-29 23:03:01.246268282 -0700
@@ -48,6 +48,10 @@
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Samsung Android phone modem - ID conflict with SPH-I500 */
+	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
