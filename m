Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351Ab2DSVSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:18:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2DSVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:18:28 -0400
Message-Id: <20120419210824.420892591@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 68/68] drm/radeon: fix load detect on rn50 with hardcoded EDIDs.
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit a09d431f344d854e4fe9cfac44f78cb8202f3eb7 upstream.

When the force changes went in back in 3.3.0, we ended up returning
disconnected in the !force case, and the connected in when forced,
as it hit the hardcoded check.

Fix it so all exits go via the hardcoded check and stop spurious
modesets on platforms with hardcoded EDIDs.

Reported-by: Evan McNabb (Red Hat)
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -976,6 +976,7 @@ radeon_dvi_detect(struct drm_connector *
 	 * cases the DVI port is actually a virtual KVM port connected to the service
 	 * processor.
 	 */
+out:
 	if ((!rdev->is_atom_bios) &&
 	    (ret == connector_status_disconnected) &&
 	    rdev->mode_info.bios_hardcoded_edid_size) {
@@ -983,7 +984,6 @@ radeon_dvi_detect(struct drm_connector *
 		ret = connector_status_connected;
 	}
 
-out:
 	/* updated in get modes as well since we need to know if it's analog or digital */
 	radeon_connector_update_scratch_regs(connector, ret);
 	return ret;


