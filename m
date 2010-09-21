Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0IUQAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:00:30 -0400
Received: from mail.nusquama.org ([85.131.211.20]:60649 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab0IUQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:00:28 -0400
X-Greylist: delayed 1720 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 12:00:28 EDT
Date: Tue, 21 Sep 2010 17:31:40 +0200
From: Max Vozeler <mvz@vozeler.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: hirofuchi@users.sourceforge.net, hschauhan@nulltrace.org,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        "Brian G. Merrell" <bgmerrell@novell.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Marco Lancione <marco@optikam.com>,
        Luc Jalbert <ljalbert@optikam.com>
Subject: [PATCH] staging: usbip: Notify usb core of port status changes
Message-ID: <20100921153140.GA4635@quark.vpn.nusquama.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes vhci to behave like dummy and 
other hcds when disconnecting a device.

Previously detaching a device from the root hub 
did not notify the usb core of the disconnect and
left the device visible.

Signed-off-by: Max Vozeler <mvz@vozeler.com>
Reported-by: Marco Lancione <marco@optikam.com>
Tested-by: Luc Jalbert <ljalbert@optikam.com>
Cc: stable@kernel.org
---
 drivers/staging/usbip/vhci_hcd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 0574d84..832608d 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -164,6 +164,8 @@ void rh_port_disconnect(int rhport)
 	 * spin_unlock(&vdev->ud.lock); */
 
 	spin_unlock_irqrestore(&the_controller->lock, flags);
+
+	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
 
-- 
1.7.1

