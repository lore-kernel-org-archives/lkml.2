Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544Ab2FHFHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759726Ab2FHFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:11 -0400
Message-Id: <20120608041842.632726783@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jan-Benedict Glaw <jan-benedict.glaw@getslash.de>,
        Jan-Benedict Glaw <jbglaw@getslash.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 13/82] drm/i915: no lvds quirk for HP t5740e Thin Client
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan-Benedict Glaw <jan-benedict.glaw@getslash.de>

commit 3347111999870c37eab1b969e90af9fdaf0334ba upstream.

This box has DisplayPort and VGA, but no LVDS. Product specs are at
http://h10010.www1.hp.com/wwpc/us/en/sm/WF25a/12454-12454-321959-338927-3640406-4282707.html?dnr=1
and dmidecode output can be found at http://www.getslash.de/bug_attachments/dmidecode-t5740e.txt

Signed-off-by: Jan-Benedict Glaw <jbglaw@getslash.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 9dee823..08eb04c 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -747,6 +747,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Hewlett-Packard HP t5740e Thin Client",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP t5740e Thin Client"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Hewlett-Packard t5745",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),


