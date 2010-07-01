Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab0GAVwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:52:16 -0400
Received: from kroah.org ([198.145.64.141]:60888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966Ab0GAVNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:44 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.489489518@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [072/200] drm/radeon/kms: dont default display priority to high on rs4xx
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 45737447ed160faaba036c0709226bf9057f7b72 upstream.

Seems to cause issues with the sound hardware.  Fixes kernel
bug 15982:
https://bugzilla.kernel.org/show_bug.cgi?id=15982

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -978,8 +978,11 @@ void radeon_update_display_priority(stru
 		/* set display priority to high for r3xx, rv515 chips
 		 * this avoids flickering due to underflow to the
 		 * display controllers during heavy acceleration.
+		 * Don't force high on rs4xx igp chips as it seems to
+		 * affect the sound card.  See kernel bug 15982.
 		 */
-		if (ASIC_IS_R300(rdev) || (rdev->family == CHIP_RV515))
+		if ((ASIC_IS_R300(rdev) || (rdev->family == CHIP_RV515)) &&
+		    !(rdev->flags & RADEON_IS_IGP))
 			rdev->disp_priority = 2;
 		else
 			rdev->disp_priority = 0;


