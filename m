Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0LHBZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:25:25 -0500
Received: from kroah.org ([198.145.64.141]:33491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511Ab0LHBCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:38 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:40 2010
Message-Id: <20101208005739.999150560@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [185/289] drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ba84cd1f2b5dd49bda9300c5a11373f7e14c3c66 upstream.

Commit d09c23de intended to add a 30ms delay to give the ADD time to
detect any TVs connected. However, it used the sdvo->is_tv flag to do so
which is dependent upon the previous detection result and not whether the
output supports TVs.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1498,10 +1498,12 @@ intel_sdvo_detect(struct drm_connector *
 	if (!intel_sdvo_write_cmd(intel_sdvo,
 			     SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0))
 		return connector_status_unknown;
-	if (intel_sdvo->is_tv) {
-		/* add 30ms delay when the output type is SDVO-TV */
+
+	/* add 30ms delay when the output type might be TV */
+	if (intel_sdvo->caps.output_flags &
+	    (SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_CVBS0))
 		mdelay(30);
-	}
+
 	if (!intel_sdvo_read_response(intel_sdvo, &response, 2))
 		return connector_status_unknown;
 


