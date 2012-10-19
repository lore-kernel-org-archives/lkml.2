Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2JSDO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:14:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:51589 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab2JSCrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jean-Christian de Rivaz <jc@eclis.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/62] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
Date: Thu, 18 Oct 2012 19:45:12 -0700
Message-Id: <20121019024303.091743819@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christian de Rivaz <jc@eclis.ch>

commit e7d491a19d3e3aac544070293891a2542ae0c565 upstream.

This USB V.92/V.32bis Controllered Modem have the USB vendor ID 0x0572
and device ID 0x1340. It need the NO_UNION_NORMAL quirk to be recognized.

Reference:
http://www.conexant.com/servlets/DownloadServlet/DSH-201723-005.pdf?docid=1725&revid=5
See idVendor and idProduct in table 6-1. Device Descriptors

Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1551,6 +1551,9 @@ static const struct usb_device_id acm_id
 					   Maybe we should define a new
 					   quirk for this. */
 	},
+	{ USB_DEVICE(0x0572, 0x1340), /* Conexant CX93010-2x UCMxx */
+	.driver_info = NO_UNION_NORMAL,
+	},
 	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},


