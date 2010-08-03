Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0HCVd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:33:28 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57760 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab0HCVd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:33:26 -0400
Date: Tue, 3 Aug 2010 23:33:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/9] drivers/gpu/drm/i915: Drop unnecessary null test
Message-ID: <Pine.LNX.4.64.1008032333040.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_for_each_entry binds its first argument to a non-null value, and thus
any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x,E;
@@

I(x,...) { <...
(
- (x == NULL) || 
  E
|
- (x != NULL) &&
  E
)
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 07da3ae..d81874d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -746,7 +746,7 @@ bool intel_pipe_has_type (struct drm_crtc *crtc, int type)
     struct drm_encoder *l_entry;
 
     list_for_each_entry(l_entry, &mode_config->encoder_list, head) {
-	    if (l_entry && l_entry->crtc == crtc) {
+	    if (l_entry->crtc == crtc) {
 		    struct intel_encoder *intel_encoder = enc_to_intel_encoder(l_entry);
 		    if (intel_encoder->type == type)
 			    return true;
@@ -3343,7 +3343,7 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
 
 	list_for_each_entry(encoder, &mode_config->encoder_list, head) {
 
-		if (!encoder || encoder->crtc != crtc)
+		if (encoder->crtc != crtc)
 			continue;
 
 		intel_encoder = enc_to_intel_encoder(encoder);
