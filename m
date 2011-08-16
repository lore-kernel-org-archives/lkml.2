Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1HPCvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1HPCvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:42 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:55 2011
Message-Id: <20110816024455.699343422@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [24/26] drm/radeon/kms: fix regression is handling >2 heads on
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 cedar/caicos

From: Alex Deucher <alexander.deucher@amd.com>

commit 33ae1827d6c3c79c5957536ec29d5a8780623147 upstream.

Need to add support for 4 crtcs when setting the possible crtcs
for the encoders.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -2323,6 +2323,9 @@ radeon_add_atom_encoder(struct drm_devic
 	default:
 		encoder->possible_crtcs = 0x3;
 		break;
+	case 4:
+		encoder->possible_crtcs = 0xf;
+		break;
 	case 6:
 		encoder->possible_crtcs = 0x3f;
 		break;


