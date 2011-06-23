Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1FWRgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:34562 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab1FWRgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 120/247] USB: add quirks entry for Keytouch QWERTY Panel
Date: Thu, 23 Jun 2011 13:33:08 -0400
Message-Id: <1308850515-15242-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3c18e30f87ac5466bddbb05cf955605efd7db025 upstream.

This patch (as1448) adds a quirks entry for the Keytouch QWERTY Panel
firmware, used in the IEC 60945 keyboard.  This device crashes during
enumeration when the computer asks for its configuration string
descriptor.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: kholis <nur.kholis.majid@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index df5dda7..0ac3810 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -65,6 +65,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Keytouch QWERTY Panel keyboard */
+	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
-- 
1.7.4.4

