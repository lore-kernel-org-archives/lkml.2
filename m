Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2LNW1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:27:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:38273 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab2LNW1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:27:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 10/22] USB: option: blacklist network interface on Huawei E173
Date: Fri, 14 Dec 2012 14:25:55 -0800
Message-Id: <20121214222252.098677657@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit f36446cf9bbebaa03a80d95cfeeafbaf68218249 upstream.

The Huawei E173 will normally appear as 12d1:1436 in Linux.  But
the modem has another mode with different device ID and a slightly
different set of descriptors. This is the mode used by Windows like
this:

  3Modem:      USB\VID_12D1&PID_140C&MI_00\6&3A1D2012&0&0000
  Networkcard: USB\VID_12D1&PID_140C&MI_01\6&3A1D2012&0&0001
  Appli.Inter: USB\VID_12D1&PID_140C&MI_02\6&3A1D2012&0&0002
  PC UI Inter: USB\VID_12D1&PID_140C&MI_03\6&3A1D2012&0&0003

All interfaces have the same ff/ff/ff class codes in this mode.
Blacklisting the network interface to allow it to be picked up by
the network driver.

Reported-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -80,6 +80,7 @@ static void option_instat_callback(struc
 #define OPTION_PRODUCT_GTM380_MODEM		0x7201
 
 #define HUAWEI_VENDOR_ID			0x12D1
+#define HUAWEI_PRODUCT_E173			0x140C
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
@@ -552,6 +553,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLX) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GKE) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLE) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff),


