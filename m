Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab1C3Vkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:40:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:61800 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583Ab1C3VII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237576"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jthomas@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [145/275] sierra: add new ID for Airprime/Sierra USB IP modem
Message-Id: <20110330210626.5E62C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jon Thomas <jthomas@redhat.com>

commit e1dc5157c574e7249dc1cd072fde2e48b3011533 upstream.

I picked up a new Sierra usb 308 (At&t Shockwave) on 2/2011 and the vendor code
is 0x0f3d

Looking up vendor and product id's I see:

0f3d  Airprime, Incorporated
 0112  CDMA 1xEVDO PC Card, PC 5220

Sierra and Airprime are somehow related and I'm guessing the At&t usb 308 might
be have some common hardware with the AirPrime SL809x.

Signed-off-by: Jon Thomas <jthomas@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/sierra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/serial/sierra.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/sierra.c	2011-03-29 22:51:08.774498652 -0700
+++ linux-2.6.35.y/drivers/usb/serial/sierra.c	2011-03-29 23:03:01.283267334 -0700
@@ -302,7 +302,9 @@
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
        { USB_DEVICE(0x413C, 0x08133) }, /* Dell Computer Corp. Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
-
+	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, id_table);
