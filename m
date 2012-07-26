Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2GZVVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:21:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2GZVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 13/23] HID: multitouch: Add support for Baanto touchscreen
Date: Thu, 26 Jul 2012 14:19:52 -0700
Message-Id: <20120726211407.064475269@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 9ed326951806c424b42dcf2e1125e25a98fb13d1 upstream.

Reported-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Tested-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    4 ++++
 3 files changed, 8 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1391,6 +1391,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BAANTO, USB_DEVICE_ID_BAANTO_MT_190W2), },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -160,6 +160,9 @@
 #define USB_VENDOR_ID_AVERMEDIA		0x07ca
 #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
 
+#define USB_VENDOR_ID_BAANTO		0x2453
+#define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -783,6 +783,10 @@ static const struct hid_device_id mt_dev
 		HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
 			USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
 
+	/* Baanto multitouch devices */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_BAANTO,
+			USB_DEVICE_ID_BAANTO_MT_190W2) },
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,


