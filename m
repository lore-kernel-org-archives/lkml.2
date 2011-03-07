Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1CGRAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:00:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39201 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1CGRAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mAxlItpav6z634RFipORwDxoQCWXOvlPQlz/1fD4YJr3HTK9BzIGBrNJsxl68bWR76
         GrXv+AGKU4Fne6VTT1xykktCdS2O6xjZfcayqqRj2NarH8S3oYfG2PGTcF/ivY0mp0ko
         VtqANdSMqubmHptoNxMV1QI7opVkX3ouWXPak=
Message-ID: <4D750F32.5050106@gmail.com>
Date: Mon, 07 Mar 2011 18:00:34 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: index i shadowed in 2nd loop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index i was already used in thhe first loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

The original was wrong, isn't it?

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 6977a1c..f73ef43 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -672,7 +672,7 @@ int drm_fb_helper_setcmap(struct fb_cmap *cmap, struct fb_info *info)
 	struct drm_crtc_helper_funcs *crtc_funcs;
 	u16 *red, *green, *blue, *transp;
 	struct drm_crtc *crtc;
-	int i, rc = 0;
+	int i, j, rc = 0;
 	int start;
 
 	for (i = 0; i < fb_helper->crtc_count; i++) {
@@ -685,7 +685,7 @@ int drm_fb_helper_setcmap(struct fb_cmap *cmap, struct fb_info *info)
 		transp = cmap->transp;
 		start = cmap->start;
 
-		for (i = 0; i < cmap->len; i++) {
+		for (j = 0; j < cmap->len; j++) {
 			u16 hred, hgreen, hblue, htransp = 0xffff;
 
 			hred = *red++;
