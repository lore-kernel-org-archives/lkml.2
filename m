Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab2FGEV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:21:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab2FGEV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:21:56 -0400
Message-Id: <20120607040348.218127674@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:56 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Bloggsian <joebloggsian@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 80/82] drm/i915: always use RPNSWREQ for turbo change requests
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8368,7 +8368,7 @@ void gen6_enable_rps(struct drm_i915_pri
 	I915_WRITE(GEN6_RP_IDLE_HYSTERSIS, 10);
 	I915_WRITE(GEN6_RP_CONTROL,
 		   GEN6_RP_MEDIA_TURBO |
-		   GEN6_RP_MEDIA_HW_MODE |
+		   GEN6_RP_MEDIA_HW_NORMAL_MODE |
 		   GEN6_RP_MEDIA_IS_GFX |
 		   GEN6_RP_ENABLE |
 		   GEN6_RP_UP_BUSY_AVG |


