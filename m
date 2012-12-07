Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423165Ab2LGA5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:57:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64094 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423029Ab2LGAzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:55:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [ 17/20] i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
Date: Thu,  6 Dec 2012 16:54:32 -0800
Message-Id: <20121207005237.724359158@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Walton <calvin.walton@kepstin.ca>

commit a51d4ed01e5bb39d2cf36a12f9976ab08872c192 upstream.

This board is incorrectly detected as having an LVDS connector,
resulting in the VGA output (the only available output on the board)
showing the console only in the top-left 1024x768 pixels, and an extra
LVDS connector appearing in X.

It's a desktop Mini-ITX board using an Atom D525 CPU with an NM10
chipset.

I've had this board for about a year, but this is the first time I
noticed the issue because I've been running it headless for most of its
life.

Signed-off-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -785,6 +785,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Gigabyte GA-D525TUD",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_BOARD_NAME, "D525TUD"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };


