Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1DZM0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57335 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1DZM0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:36 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: maximilian attems <max@stro.at>, Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 11/21] drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:34 +0200
Message-Id: <1303820794-3713-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 11/21] drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 13a926e770fd177301c3489a46f561d8bc492c3e Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 24 Nov 2010 17:37:17 +0000
Subject: [PATCH 11/21] drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable

commit ba84cd1f2b5dd49bda9300c5a11373f7e14c3c66 upstream.

Commit d09c23de intended to add a 30ms delay to give the ADD time to
detect any TVs connected. However, it used the sdvo->is_tv flag to do so
which is dependent upon the previous detection result and not whether the
output supports TVs.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ trivial backport -maks ]
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 48daee5..fe83986 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1693,10 +1693,10 @@ static enum drm_connector_status intel_sdvo_detect(struct drm_connector *connect

 	intel_sdvo_write_cmd(intel_output,
 			     SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0);
-	if (sdvo_priv->is_tv) {
-		/* add 30ms delay when the output type is SDVO-TV */
-		mdelay(30);
-	}
+	/* add 30ms delay when the output type might be TV */
+	if (sdvo_priv->caps.output_flags &
+	    (SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_CVBS0))
+ 		mdelay(30);
 	status = intel_sdvo_read_response(intel_output, &response, 2);

 	DRM_DEBUG_KMS("SDVO response %d %d\n", response & 0xff, response >> 8);
--
1.7.0.4

