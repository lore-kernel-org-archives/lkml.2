Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab2FGERr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:17:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab2FGERo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:44 -0400
Message-Id: <20120607040341.198389228@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:09 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan-Benedict Glaw <jbglaw@getslash.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 33/82] drm/i915: no lvds quirk for HP t5740e Thin Client
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan-Benedict Glaw <jan-benedict.glaw@getslash.de>

commit 3347111999870c37eab1b969e90af9fdaf0334ba upstream.

This box has DisplayPort and VGA, but no LVDS. Product specs are at
http://h10010.www1.hp.com/wwpc/us/en/sm/WF25a/12454-12454-321959-338927-3640406-4282707.html?dnr=1
and dmidecode output can be found at http://www.getslash.de/bug_attachments/dmidecode-t5740e.txt

Signed-off-by: Jan-Benedict Glaw <jbglaw@getslash.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -747,6 +747,14 @@ static const struct dmi_system_id intel_
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


