Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1CIJTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:19:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55880 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab1CIJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:19:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: [PATCH] Apply OPTION_BLACKLIST_SENDSETUP also for ZTE MF626
Date: Wed,  9 Mar 2011 09:19:48 +0000
Message-Id: <1299662388-2819-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On https://bugs.launchpad.net/ubuntu/+source/linux/+bug/636091, one of
the cases reported is a big timeout on option_send_setup, which causes
some side effects as tty_lock is held. Looks like some of ZTE MF626
devices also don't like the RTS/DTR setting in option_send_setup, like
with 4G XS Stick W14. The reporter confirms which this it solves the
long freezes in his system.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/option.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5f46838..75c7f45 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -652,7 +652,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0028, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0029, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0030, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626, 0xff,
+	  0xff, 0xff), .driver_info = (kernel_ulong_t)&four_g_w14_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0032, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0033, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0034, 0xff, 0xff, 0xff) },
-- 
1.7.1

