Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1HNQGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1HNQGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.047977033@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Reim <reimth@gmail.com>,
        Stephen Michaels <Stephen.Micheals@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [22/90] drm/radeon: Log Subsystem Vendor and Device Information
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Reim <reimth@gmail.com>

commit d522d9cc5bdd41214084383fc3e6d882f6916a78 upstream.

    Log PCI subsystem vendor and subsystem device ID in addition to
    PCI vendor and device ID during kernel mode initialisation. This helps
    to better identify radeon devices of third-party vendors, e. g. for
    bug analysis.

    Tested for kernel 2.6.35, 2.6.38 and 3.0 on Asus M2A-VM HDMI board

Signed-off-by: Thomas Reim <reimth@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Acked-by: Stephen Michaels <Stephen.Micheals@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -704,8 +704,9 @@ int radeon_device_init(struct radeon_dev
 	rdev->gpu_lockup = false;
 	rdev->accel_working = false;
 
-	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
-		radeon_family_name[rdev->family], pdev->vendor, pdev->device);
+	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
+		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
+		pdev->subsystem_vendor, pdev->subsystem_device);
 
 	/* mutex initialization are all done here so we
 	 * can recall function without having locking issues */


