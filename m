Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0GASYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:24:15 -0400
Received: from kroah.org ([198.145.64.141]:40730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094Ab0GASYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:08 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.340110131@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [patch 113/149] drm/i915: give up on 8xx lid status
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 7b9c5abee98c54f85bcc04bd4d7ec8d5094c73f4 upstream.

These old machines more often than not lie about their lid state.  So
don't use it to detect LVDS presence, but leave the event handler to
deal with lid open/close, when we might need to reset the mode.

Fixes kernel bug #15248

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -648,8 +648,12 @@ static const struct dmi_system_id bad_li
  */
 static enum drm_connector_status intel_lvds_detect(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	enum drm_connector_status status = connector_status_connected;
 
+	if (IS_I8XX(dev))
+		return connector_status_connected;
+
 	if (!acpi_lid_open() && !dmi_check_system(bad_lid_status))
 		status = connector_status_disconnected;
 


