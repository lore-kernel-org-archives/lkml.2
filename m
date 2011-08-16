Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1HPCvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1HPCvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:38 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:55 2011
Message-Id: <20110816024455.548556218@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [23/26] drm/radeon/kms: dont enable connectors that are off in the
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 hotplug handler

From: Alex Deucher <alexander.deucher@amd.com>

commit 73104b5cfe3067d68f2c2de3f3d4d4964c55873e upstream.

If we get a hotplug event on an connector that is off, don't
attempt to turn it on or off, it should already be off.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=728228

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -60,6 +60,10 @@ void radeon_connector_hotplug(struct drm
 
 	radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 
+	/* if the connector is already off, don't turn it back on */
+	if (connector->dpms != DRM_MODE_DPMS_ON)
+		return;
+
 	/* powering up/down the eDP panel generates hpd events which
 	 * can interfere with modesetting.
 	 */


