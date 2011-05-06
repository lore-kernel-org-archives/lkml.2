Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1EFANa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:13:30 -0400
Received: from kroah.org ([198.145.64.141]:32871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab1EFAN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.151828861@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [patch 19/38] drm/radeon: fix regression on atom cards with hardcoded EDID record.
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit eaa4f5e1d0b816291a59a47917e569c0384f2b6f upstream.

Since fafcf94e2b5732d1e13b440291c53115d2b172e9 introduced an edid size, it seems to have broken this path.

This manifest as oops on T500 Lenovo laptops with dual graphics primarily.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33812

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1599,9 +1599,10 @@ struct radeon_encoder_atom_dig *radeon_a
 							memcpy((u8 *)edid, (u8 *)&fake_edid_record->ucFakeEDIDString[0],
 							       fake_edid_record->ucFakeEDIDLength);
 
-							if (drm_edid_is_valid(edid))
+							if (drm_edid_is_valid(edid)) {
 								rdev->mode_info.bios_hardcoded_edid = edid;
-							else
+								rdev->mode_info.bios_hardcoded_edid_size = edid_size;
+							} else
 								kfree(edid);
 						}
 					}


