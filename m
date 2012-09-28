Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030867Ab2I1TJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:09:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030788Ab2I1TGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard Zhao <richard.zhao@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 252/262] usb: chipidea: udc: fix error path in udc_start()
Date: Fri, 28 Sep 2012 11:53:01 -0700
Message-Id: <20120928183028.268000998@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit c9d1f947a85e38b6dded469470c95ed62430cb3f upstream.

This patch fixes the error path of udc_start(). Now NULL is used to
unset the peripheral with otg_set_peripheral().

Cc: stable <stable@vger.kernel.org>
Reviewed-by: Richard Zhao <richard.zhao@freescale.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1747,7 +1747,7 @@ static int udc_start(struct ci13xxx *udc
 
 remove_trans:
 	if (udc->transceiver) {
-		otg_set_peripheral(udc->transceiver->otg, &udc->gadget);
+		otg_set_peripheral(udc->transceiver->otg, NULL);
 		usb_put_transceiver(udc->transceiver);
 	}
 


