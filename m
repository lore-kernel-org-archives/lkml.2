Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1FWSMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:12:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:34572 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab1FWRgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Maciej Szmigiero <mhej@o2.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 122/247] USB: Add quirk for Samsung Android phone modem
Date: Thu, 23 Jun 2011 13:33:10 -0400
Message-Id: <1308850515-15242-63-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Szmigiero <mhej@o2.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 72a012ce0a02c6c616676a24b40ff81d1aaeafda upstream.

My Galaxy Spica needs this quirk when in modem mode, otherwise
it causes endless USB bus resets and is unusable in this mode.

Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
for the modem part.
That's why in addition to this patch the visor driver must be prevented
from binding to SPH-I500 ID, so ACM driver can do that.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 0ac3810..99f2d61 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -45,6 +45,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Samsung Android phone modem - ID conflict with SPH-I500 */
+	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.7.4.4

