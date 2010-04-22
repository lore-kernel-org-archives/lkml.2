Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab0DVUTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:19:31 -0400
Received: from kroah.org ([198.145.64.141]:59781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab0DVUAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:39 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:11 2010
Message-Id: <20100422195411.585836206@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [068/139] drm/radeon/kms: disable the tv encoder when tv/cv is not in use
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit d3a67a43b0460bae3e2ac14092497833344ac10d upstream.

Switching between TV and VGA caused VGA to break on some systems
since the TV encoder was left enabled when VGA was used.

fixes fdo bug 25520.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1276,8 +1276,12 @@ radeon_atom_encoder_mode_set(struct drm_
 	case ENCODER_OBJECT_ID_INTERNAL_DAC2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DAC2:
 		atombios_dac_setup(encoder, ATOM_ENABLE);
-		if (radeon_encoder->active_device & (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT))
-			atombios_tv_setup(encoder, ATOM_ENABLE);
+		if (radeon_encoder->devices & (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT)) {
+			if (radeon_encoder->active_device & (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT))
+				atombios_tv_setup(encoder, ATOM_ENABLE);
+			else
+				atombios_tv_setup(encoder, ATOM_DISABLE);
+		}
 		break;
 	}
 	atombios_apply_encoder_quirks(encoder, adjusted_mode);


