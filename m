Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2I1Ooy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:44:54 -0400
Received: from www.eclis.ch ([217.162.2.166]:60096 "EHLO mail.eclis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab2I1Oox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:44:53 -0400
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 10:44:53 EDT
From: jc@eclis.ch
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
Date: Fri, 28 Sep 2012 16:16:04 +0200
Message-Id: <1348841764-26873-1-git-send-email-jc@eclis.ch>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christian de Rivaz <jc@eclis.ch>

This USB V.92/V.32bis Controllered Modem have the USB vendor ID 0x0572
and device ID 0x1340. It need the NO_UNION_NORMAL quirk to be recognized.

Reference:
http://www.conexant.com/servlets/DownloadServlet/DSH-201723-005.pdf?docid=1725&revid=5

Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f763ed7..e8007b8 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1551,6 +1551,9 @@ static const struct usb_device_id acm_ids[] = {
 					   Maybe we should define a new
 					   quirk for this. */
 	},
+	{ USB_DEVICE(0x0572, 0x1340), /* Conexant CX93010-2x UCMxx */
+	.driver_info = NO_UNION_NORMAL,
+	},
 	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},
-- 
1.7.2.5

