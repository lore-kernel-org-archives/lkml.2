Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1ABHWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:34635 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1ABHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Toby Gray <toby.gray@realvnc.com>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 053/260] USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
Date: Sun,  2 Jan 2011 02:15:49 -0500
Message-Id: <1293952756-15010-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:03.0866 (UTC) FILETIME=[9D4FFDA0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toby Gray <toby.gray@realvnc.com>

commit 4035e45632c2a8bb4edae83c20447051bd9a9604 upstream.

S60 phones from Nokia and Samsung expose two ACM channels. The first is a modem
with a standard AT-command interface, which is picked up correctly by CDC-ACM.

The second ACM port is marked as having a vendor-specific protocol. This means
that the ACM driver will not claim the second channel by default.

This adds support for the second ACM channel for the following devices:
    Nokia E63
    Nokia E75
    Nokia 6760 Slide
    Nokia E52
    Nokia E55
    Nokia E72
    Nokia X6
    Nokia N97 Mini
    Nokia 5800 Xpressmusic
    Nokia E90
    Samsung GTi8510 (INNOV8)

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index bbcdabe..8c388f8 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1487,6 +1487,11 @@ static int acm_reset_resume(struct usb_interface *intf)
 		USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM, \
 		USB_CDC_ACM_PROTO_VENDOR)
 
+#define SAMSUNG_PCSUITE_ACM_INFO(x) \
+		USB_DEVICE_AND_INTERFACE_INFO(0x04e7, x, \
+		USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM, \
+		USB_CDC_ACM_PROTO_VENDOR)
+
 /*
  * USB driver structure.
  */
@@ -1597,6 +1602,17 @@ static const struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x0108), }, /* Nokia 5320 XpressMusic 2G */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01f5), }, /* Nokia N97, RM-505 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x02e3), }, /* Nokia 5230, RM-588 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0178), }, /* Nokia E63 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x010e), }, /* Nokia E75 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x02d9), }, /* Nokia 6760 Slide */
+	{ NOKIA_PCSUITE_ACM_INFO(0x01d0), }, /* Nokia E52 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0223), }, /* Nokia E72 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0275), }, /* Nokia X6 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x026c), }, /* Nokia N97 Mini */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0154), }, /* Nokia 5800 XpressMusic */
+	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
+	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 
-- 
1.7.3.3

