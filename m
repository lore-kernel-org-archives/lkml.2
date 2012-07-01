Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2GAS15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:27:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46915 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab2GASQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:25 -0400
Message-Id: <20120701172009.513059225@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 20/48] drm/edid: dont return stack garbage from supports_rb
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b196a4980ff7bb54db478e2a408dc8b12be15304 upstream.

We need to initialize this to false, because the is_rb callback only
ever sets it to true.

Noticed while reading through the code.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_edid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index eb92fe2..5873e48 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -610,7 +610,7 @@ static bool
 drm_monitor_supports_rb(struct edid *edid)
 {
 	if (edid->revision >= 4) {
-		bool ret;
+		bool ret = false;
 		drm_for_each_detailed_block((u8 *)edid, is_rb, &ret);
 		return ret;
 	}


