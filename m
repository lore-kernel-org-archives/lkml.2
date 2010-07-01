Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0GASpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:45:07 -0400
Received: from kroah.org ([198.145.64.141]:35528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757793Ab0GASXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:15 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:11 2010
Message-Id: <20100701173211.103422529@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 051/149] drm/edid: Fix 1024x768@85Hz
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 61dd98fad58f945ed720ba132681acb58fcee015 upstream.

Having hsync both start and end on pixel 1072 ain't gonna work very
well.  Matches the X server's list.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Tested-By: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_edid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -324,7 +324,7 @@ static struct drm_display_mode drm_dmt_m
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
 	/* 1024x768@85Hz */
 	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 94500, 1024, 1072,
-		   1072, 1376, 0, 768, 769, 772, 808, 0,
+		   1168, 1376, 0, 768, 769, 772, 808, 0,
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
 	/* 1152x864@75Hz */
 	{ DRM_MODE("1152x864", DRM_MODE_TYPE_DRIVER, 108000, 1152, 1216,


