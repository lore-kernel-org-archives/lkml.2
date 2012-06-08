Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758Ab2FHFR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:17:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43241 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761258Ab2FHFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:26 -0400
Message-Id: <20120608041843.028768207@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Joe Bloggsian <joebloggsian@gmail.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 16/82] drm/i915: always use RPNSWREQ for turbo change requests
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 89ba829e38bd500f438bc08af4229204c8ed7f35 upstream.

Media turbo requests can either use RPVSWREQ or RPNSWREQ to indicate
what the interrupt handler should do.  Since we only deal with the
latter in our turbo code, make the media engine use that for turbo
requests.

Tested-by: Joe Bloggsian <joebloggsian@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8005,7 +8005,7 @@
 	I915_WRITE(GEN6_RP_IDLE_HYSTERSIS, 10);
 	I915_WRITE(GEN6_RP_CONTROL,
 		   GEN6_RP_MEDIA_TURBO |
-		   GEN6_RP_MEDIA_HW_MODE |
+		   GEN6_RP_MEDIA_HW_NORMAL_MODE |
 		   GEN6_RP_MEDIA_IS_GFX |
 		   GEN6_RP_ENABLE |
 		   GEN6_RP_UP_BUSY_AVG |


