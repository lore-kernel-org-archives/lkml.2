Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1ABIGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:06:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:34539 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1ABHWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:10 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Philippe Corbes <philippe.corbes@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 054/260] USB: cdc-acm: Add pseudo modem without AT command capabilities
Date: Sun,  2 Jan 2011 02:15:50 -0500
Message-Id: <1293952756-15010-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:05.0038 (UTC) FILETIME=[9E02D2E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Corbes <philippe.corbes@gmail.com>

commit 5b239f0aebd4dd6f85b13decf5e18e86e35d57f0 upstream.

cdc-acm.c : Manage pseudo-modem without AT commands capabilities
  Enable to drive electronic simple gadgets based on microcontrolers.
  The Interface descriptor is like this:
    bInterfaceClass         2 Communications
    bInterfaceSubClass      2 Abstract (modem)
    bInterfaceProtocol      0 None

Signed-off-by: Philippe Corbes <philippe.corbes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8c388f8..ffbf1aa 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1621,6 +1621,10 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = NOT_A_MODEM,
        	},
 
+	/* control interfaces without any protocol set */
+	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
+		USB_CDC_PROTO_NONE) },
+
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_ACM_PROTO_AT_V25TER) },
-- 
1.7.3.3

