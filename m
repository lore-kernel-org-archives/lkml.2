Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2IIXjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:39:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51051 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489Ab2IIXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:49 -0400
Message-Id: <20120909224154.564568187@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christoph Bumiller <e0425955@student.tuwien.ac.at>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 27/95] drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Bumiller <e0425955@student.tuwien.ac.at>

commit af5e7d84b0ec45b2b614b0d6e3657cbdceaa21f9 upstream.

Signed-off-by: Christoph Bumiller <e0425955@student.tuwien.ac.at>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
[bwh: Backported to 3.2: register value is in the local 'data' variable]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nvd0_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvd0_display.c
+++ b/drivers/gpu/drm/nouveau/nvd0_display.c
@@ -472,7 +472,7 @@ static int
 nvd0_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 {
 	struct nouveau_crtc *nv_crtc = nouveau_crtc(crtc);
-	const u32 data = (y << 16) | x;
+	const u32 data = (y << 16) | (x & 0xffff);
 
 	nv_wr32(crtc->dev, 0x64d084 + (nv_crtc->index * 0x1000), data);
 	nv_wr32(crtc->dev, 0x64d080 + (nv_crtc->index * 0x1000), 0x00000000);


