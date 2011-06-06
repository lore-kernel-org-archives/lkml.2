Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1FFOJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:09:31 -0400
Received: from realvnc.com ([146.101.152.142]:52405 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab1FFOJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:09:28 -0400
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 10:09:28 EDT
From: Toby Gray <toby.gray@realvnc.com>
To: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toby Gray <toby.gray@realvnc.com>
Subject: [PATCH 1/1] USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7
Date: Mon,  6 Jun 2011 14:52:48 +0100
Message-Id: <1307368368-26791-1-git-send-email-toby.gray@realvnc.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Nokia E7 and C7 to the list of devices in cdc-acm, allowing
the secondary ACM channel on the device to be exposed. Without this patch
the ACM driver won't claim this secondary channel as it's marked as
having a vendor-specific protocol.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 395a347..dac7676 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1530,6 +1530,8 @@ static const struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x0302), }, /* Nokia N8 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0335), }, /* Nokia E7 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x03cd), }, /* Nokia C7 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
-- 
1.7.0.4

