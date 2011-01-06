Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1AFAhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:37:48 -0500
Received: from kroah.org ([198.145.64.141]:36056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab1AFAbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:34 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.793364768@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [128/152] drm/radeon/kms/evergreen: reset the grbm blocks at resume and init
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 86f5c9edbb3bac37cc8cee6528a929005ba72aad upstream.

This fixes module reloading and resume as the gfx block seems to
be left in a bad state in some cases.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2097,6 +2097,11 @@ int evergreen_resume(struct radeon_devic
 {
 	int r;
 
+	/* reset the asic, the gfx blocks are often in a bad state
+	 * after the driver is unloaded or after a resume
+	 */
+	if (radeon_asic_reset(rdev))
+		dev_warn(rdev->dev, "GPU reset failed !\n");
 	/* Do not reset GPU before posting, on rv770 hw unlike on r500 hw,
 	 * posting will perform necessary task to bring back GPU into good
 	 * shape.
@@ -2193,6 +2198,11 @@ int evergreen_init(struct radeon_device
 	r = radeon_atombios_init(rdev);
 	if (r)
 		return r;
+	/* reset the asic, the gfx blocks are often in a bad state
+	 * after the driver is unloaded or after a resume
+	 */
+	if (radeon_asic_reset(rdev))
+		dev_warn(rdev->dev, "GPU reset failed !\n");
 	/* Post card if necessary */
 	if (!evergreen_card_posted(rdev)) {
 		if (!rdev->bios) {


