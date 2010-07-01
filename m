Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0GAV0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:26:38 -0400
Received: from kroah.org ([198.145.64.141]:33296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab0GAVPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:44 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:03 2010
Message-Id: <20100701174303.311247741@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Eric Anholt <eric@anholt.net>
Subject: [199/200] drm/i915: Dont touch PORT_HOTPLUG_EN in intel_dp_detect()
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karsten Wiese <fzuuzf@googlemail.com>

commit 6e0032f0ae4440e75256bee11b163552cae21962 upstream.

PORT_HOTPLUG_EN has allready been setup in i915_driver_irq_postinstall(),
when intel_dp_detect() runs.

Delete the DP[BCD]_HOTPLUG_INT_EN defines, they are not referenced anymore.

I found this while searching for a fix for
        https://bugzilla.redhat.com/show_bug.cgi?id=528312

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1180,16 +1180,6 @@ intel_dp_detect(struct drm_connector *co
 	if (HAS_PCH_SPLIT(dev))
 		return ironlake_dp_detect(connector);
 
-	temp = I915_READ(PORT_HOTPLUG_EN);
-
-	I915_WRITE(PORT_HOTPLUG_EN,
-	       temp |
-	       DPB_HOTPLUG_INT_EN |
-	       DPC_HOTPLUG_INT_EN |
-	       DPD_HOTPLUG_INT_EN);
-
-	POSTING_READ(PORT_HOTPLUG_EN);
-
 	switch (dp_priv->output_reg) {
 	case DP_B:
 		bit = DPB_HOTPLUG_INT_STATUS;


