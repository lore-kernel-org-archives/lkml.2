Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677Ab2FHFKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:10:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760127Ab2FHFHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:34 -0400
Message-Id: <20120608041842.501720180@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marc Gariepy <mgariepy@ubuntu.com>,
        Adam Jackson <ajax@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 12/82] drm/i915: Ignore LVDS on hp t5745 and hp st5747 thin client
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Gariepy <mgariepy@ubuntu.com>

commit f5b8a7ed0405d48fd096acce48fbefbed77fb055 upstream.

Add a no_lvds quirk for the HP t5745 and HP st5747 thin clients

dmidecode for those thin clients are attached in thoses bugs:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/911916
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/911920

Signed-off-by: Marc Gariepy <mgariepy@ubuntu.com>
Acked-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context because these quirk entries aren't
 consistently cc'd to stable and are now being applied out of order]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -741,6 +741,22 @@
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Hewlett-Packard t5745",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "hp t5745"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Hewlett-Packard st5747",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "hp st5747"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "MSI Wind Box DC500",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),


