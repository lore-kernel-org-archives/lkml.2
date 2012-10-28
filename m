Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2J1Xs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:48:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41804 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315Ab2J1X1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:03 -0400
Message-Id: <20121028231609.609499647@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean-Christian de Rivaz <jc@eclis.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 105/105] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


