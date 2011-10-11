Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1JKRFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:05:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:05:51 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:13 2011
Message-Id: <20111011165713.083634345@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:41 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [31/38] drm/radeon/kms: use hardcoded dig encoder to transmitter mapping for DCE4.1
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cb7cf41961fe10773c491c75ae73539ad4bbed66 upstream.

The encoders are supposedly fully routeable, but changing the mapping
doesn't always seem to take.  Using a hardcoded mapping is much more
reliable.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41366

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1755,9 +1755,12 @@ static int radeon_atom_pick_dig_encoder(
 	/* DCE4/5 */
 	if (ASIC_IS_DCE4(rdev)) {
 		dig = radeon_encoder->enc_priv;
-		if (ASIC_IS_DCE41(rdev))
-			return radeon_crtc->crtc_id;
-		else {
+		if (ASIC_IS_DCE41(rdev)) {
+			if (dig->linkb)
+				return 1;
+			else
+				return 0;
+		} else {
 			switch (radeon_encoder->encoder_id) {
 			case ENCODER_OBJECT_ID_INTERNAL_UNIPHY:
 				if (dig->linkb)


