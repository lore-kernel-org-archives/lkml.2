Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1CPXq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:46:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:60267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1CPXqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:46:21 -0400
Date: Thu, 17 Mar 2011 00:46:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Michal_Mal=FD?= <madcatxster@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Product ID for Logitech Driving Force Pro wheel
In-Reply-To: <alpine.LNX.2.00.1103141311410.19969@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1103170045070.19969@pobox.suse.cz>
References: <201103102153.44137.madcatxster@gmail.com> <alpine.LNX.2.00.1103141311410.19969@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Jiri Kosina wrote:

> > This trivial fix adds correct product ID for Logitech Driving Force Pro wheel 
> > when it operates in native mode. This is needed to get force feedback working.
> 
> Hi Michal,
> 
> could you please fixup and re-post your patch, according to 
> Documentation/SubmittingPatches?
> 
> Namely
> 
> - please add your Signed-off-by: line
> - please send a patch in 'condensed' form, i.e. we don't want separate 
>   diffs for separate files

As there has been no response, I have applied the patch below to my tree. 
Thanks a lot for your report!

>From 5623a24a80814fe471e777f12b9dbbb0f77e002e Mon Sep 17 00:00:00 2001
From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 17 Mar 2011 00:43:23 +0100
Subject: [PATCH] HID: add support for Logitech Driving Force Pro wheel

Add force feedback support for Logitech Driving Force Pro wheel.

Device IDs reported by Michal Malý.

Reported-by: Michal Malý <madcatxster@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    1 +
 drivers/hid/hid-lg.c   |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 295e248..f99413b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1368,6 +1368,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_FLIGHT_SYSTEM_G940) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5f5cc91..cb21c41 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -383,6 +383,7 @@
 #define USB_DEVICE_ID_LOGITECH_WHEEL	0xc294
 #define USB_DEVICE_ID_LOGITECH_WINGMAN_FFG	0xc293
 #define USB_DEVICE_ID_LOGITECH_MOMO_WHEEL	0xc295
+#define USB_DEVICE_ID_LOGITECH_DFP_WHEEL	0xc298
 #define USB_DEVICE_ID_LOGITECH_G25_WHEEL	0xc299
 #define USB_DEVICE_ID_LOGITECH_WII_WHEEL	0xc29c
 #define USB_DEVICE_ID_LOGITECH_ELITE_KBD	0xc30a
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index aef4104..3da9040 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -377,6 +377,8 @@ static const struct hid_device_id lg_devices[] = {
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL),
 		.driver_data = LG_FF },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL),
+		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WII_WHEEL),
 		.driver_data = LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WINGMAN_FFG ),
-- 
Jiri Kosina
SUSE Labs, Novell Inc.
