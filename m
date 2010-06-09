Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0FISMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:12:55 -0400
Received: from gromit.mixdown.ca ([208.68.91.47]:54696 "EHLO gromit.mixdown.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab0FISMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:12:53 -0400
X-Greylist: delayed 2040 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:12:53 EDT
To: vojtech@suse.cz, linux-kernel@vger.kernel.org
Subject: [patch] add quirk to fix volume wheel on Toshiba U300 laptops
From: Andrew Kohlsmith <akohlsmith@mixdown.ca>
Date: Wed, 9 Jun 2010 13:38:50 -0400
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rG9DMP8f6+qa2xA"
Message-Id: <201006091338.51495.akohlsmith@mixdown.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_rG9DMP8f6+qa2xA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Good afternoon,

Here is a small patch which adds a quirk match for these laptops; the volume 
wheel on them does not stop when you move it (the wheel does not send 'up' 
keycodes).

Patch applies cleanly to linus' tree as of about...10 minutes ago. :-)

Regards,
Andrew

--Boundary-00=_rG9DMP8f6+qa2xA
Content-Type: text/x-patch;
  charset="utf-8";
  name="toshiba-u300-volume-sw-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="toshiba-u300-volume-sw-fix.diff"

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index d358ef8..f1e1801 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1715,6 +1715,22 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 		.callback = atkbd_setup_scancode_fixup,
 		.driver_data = atkbd_oqo_01plus_scancode_fixup,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U300"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_volume_forced_release_keys,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite Pro U300"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_volume_forced_release_keys,
+	},
 	{ }
 };
 

--Boundary-00=_rG9DMP8f6+qa2xA--
