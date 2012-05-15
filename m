Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab2EOCSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:49 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53156 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915Ab2EOCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 058/179] USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7
Date: Mon, 14 May 2012 22:12:34 -0400
Message-ID: <1337048075-6132-59-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toby Gray <toby.gray@realvnc.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4061fde2fa80f40cb27114f60500d38d0afcf350 upstream.

This adds the Nokia E7 and C7 to the list of devices in cdc-acm, allowing
the secondary ACM channel on the device to be exposed. Without this patch
the ACM driver won't claim this secondary channel as it's marked as
having a vendor-specific protocol.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 657b434..e907cfd 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1619,6 +1619,8 @@ static const struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x0302), }, /* Nokia N8 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0335), }, /* Nokia E7 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x03cd), }, /* Nokia C7 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
-- 
1.7.9.6

