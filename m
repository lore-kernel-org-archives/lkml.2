Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1ABHZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:36941 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1ABHZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Max Vozeler <mvz@vozeler.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 219/260] staging: usbip: Notify usb core of port status changes
Date: Sun,  2 Jan 2011 02:18:35 -0500
Message-Id: <1293952756-15010-220-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:08.0948 (UTC) FILETIME=[0BA14340:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Vozeler <mvz@vozeler.com>

commit 0c9a32f0192e656daa2ff3c9149f6d71b4a1b873 upstream.

This patch changes vhci to behave like dummy and
other hcds when disconnecting a device.

Previously detaching a device from the root hub
did not notify the usb core of the disconnect and
left the device visible.

Signed-off-by: Max Vozeler <mvz@vozeler.com>
Reported-by: Marco Lancione <marco@optikam.com>
Tested-by: Luc Jalbert <ljalbert@optikam.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/vhci_hcd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 0b17661..7604519 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -164,6 +164,8 @@ void rh_port_disconnect(int rhport)
 	 * spin_unlock(&vdev->ud.lock); */
 
 	spin_unlock_irqrestore(&the_controller->lock, flags);
+
+	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
 
-- 
1.7.3.3

