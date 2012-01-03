Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2ACWvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:51:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab2ACWlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:25 2012
Message-Id: <20120103223324.966632976@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Jean Delvare <khali@linux-fr.org>, Dave Airlie <airlied@redhat.com>
Subject: [47/75] drm/radeon/kms: bail on BTC parts if MC ucode is missing
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 77e00f2ea94abee1ad13bdfde19cf7aa25992b0e upstream.

We already do this for cayman, need to also do it for
BTC parts.  The default memory and voltage setup is not
adequate for advanced operation.  Continuing will
result in an unusable display.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3258,6 +3258,18 @@ int evergreen_init(struct radeon_device
 			rdev->accel_working = false;
 		}
 	}
+
+	/* Don't start up if the MC ucode is missing on BTC parts.
+	 * The default clocks and voltages before the MC ucode
+	 * is loaded are not suffient for advanced operations.
+	 */
+	if (ASIC_IS_DCE5(rdev)) {
+		if (!rdev->mc_fw && !(rdev->flags & RADEON_IS_IGP)) {
+			DRM_ERROR("radeon: MC ucode required for NI+.\n");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 


