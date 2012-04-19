Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2DSVFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:05:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2DSVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:05:30 -0400
Message-Id: <20120419210303.307584428@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 02/75] drm/radeon/kms: fix DVO setup on some r4xx chips
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit afceb9319f21b18ee3bc15ee9a5f92e18ef8a8c9 upstream.

Some r4xx chips have the wrong frev in the
DVOEncoderControl table.  It should always be 1
on r4xx.  Fixes modesetting on DVO on r4xx chips
with the bad frev.

Reported by twied on #radeon.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -230,6 +230,10 @@ atombios_dvo_setup(struct drm_encoder *e
 	if (!atom_parse_cmd_header(rdev->mode_info.atom_context, index, &frev, &crev))
 		return;
 
+	/* some R4xx chips have the wrong frev */
+	if (rdev->family <= CHIP_RV410)
+		frev = 1;
+
 	switch (frev) {
 	case 1:
 		switch (crev) {


