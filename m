Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1ACOm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:42:56 -0500
Received: from mailout11.t-online.de ([194.25.134.85]:58754 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab1ACOmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:42:55 -0500
X-Greylist: delayed 1050 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 09:42:55 EST
Message-ID: <4D21DC41.8070408@t-online.de>
Date: Mon, 03 Jan 2011 15:25:05 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: airlied@linux.ie
CC: eric@anholt.net, jesse.barnes@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de
Subject: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: VOMTZ6ZvrhR2d4c01tVFX2EgF5svuFIrvS-IKw+sngBWIlKsrCWqRrdOSsYC7X4QvP
X-TOI-MSGID: 3ad1a40c-7dcd-4c04-aa4e-9da4f8a7d283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody!

The AOpen i915GMm-HFS is a desktop motherboard for the Intel Pentium M.
A mobile chipset is used
(Intel 915GM / ICH6-M). Kernel 2.6.31.14 works fine for that mobo, but
from 2.6.32 on graphics support
is broken because the i915 driver "detects" an lvds device with a
resolution of 1024x768 pixels that in reality
is not present. Unfortunately the driver assumes that the "detected"
lvds is the primary screen and uses the
wrong resolution also for the real VGA and DVI connectors.

Obvious solution: The motherboard needs an entry in the intel_no_lvds
blacklist in intel_lvds.c

Kernel version       Comment
======================
2.6.37-rc8-git2      patch applies cleanly and fixes the problem.
2.6.36.2:                patch applies with a few lines offset, fixed
the problem
2.6.32 to 2.6.35:   Not tested
2.6.31 / older         Not needed

Signed-off-by: Knut Petersen <knut_petersen@t-online.de>


--- linux-2.6.37-rc8-git2/drivers/gpu/drm/i915/intel_lvds.c   
2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37-rc8-git2-kp/drivers/gpu/drm/i915/intel_lvds.c   
2011-01-03 13:48:38.000000000 +0100
@@ -708,6 +708,14 @@ static const struct dmi_system_id intel_
             DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
         },
     },
+        {
+                .callback = intel_no_lvds_dmi_callback,
+                .ident = "AOpen motherboard i915GMm-HFS",
+                .matches = {
+                        DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+                        DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+                },
+        },
     {
         .callback = intel_no_lvds_dmi_callback,
         .ident = "Clientron U800",

