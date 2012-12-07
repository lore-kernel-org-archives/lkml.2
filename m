Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423825Ab2LGBCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:02:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423650Ab2LGBAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [ 22/27] net: qmi_wwan: add Huawei E173
Date: Thu,  6 Dec 2012 16:59:06 -0800
Message-Id: <20121207005832.391616764@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit ba695af067f9cadfec84457ac06b44e3fa849b15 upstream.

The Huawei E173 is a QMI/wwan device which normally appear
as 12d1:1436 in Linux. The descriptors displayed in that
mode will be picked up by cdc_ether.  But the modem has
another mode with a different device ID and a slightly
different set of descriptors. This is the mode used by
Windows like this:

3Modem:      USB\VID_12D1&PID_140C&MI_00\6&3A1D2012&0&0000
Networkcard: USB\VID_12D1&PID_140C&MI_01\6&3A1D2012&0&0001
Appli.Inter: USB\VID_12D1&PID_140C&MI_02\6&3A1D2012&0&0002
PC UI Inter: USB\VID_12D1&PID_140C&MI_03\6&3A1D2012&0&0003

Reported-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -398,6 +398,7 @@ static const struct usb_device_id produc
 	},
 
 	/* 3. Combined interface devices matching on interface number */
+	{QMI_FIXED_INTF(0x12d1, 0x140c, 1)},	/* Huawei E173 */
 	{QMI_FIXED_INTF(0x19d2, 0x0002, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0012, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0017, 3)},


