Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab0G3S3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:29:32 -0400
Received: from kroah.org ([198.145.64.141]:58203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759907Ab0G3RzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:39 2010
Message-Id: <20100730175139.673826522@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [067/205] drm/radeon/kms: fix possible mis-detection of sideport on rs690/rs740
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 5099fa7f23d3711538cbe9fe072b4ce1ba814035 upstream.

Check ulBootUpMemoryClock on AMD IGPs.

Fix regression noticed by Torsten Kaiser <just.for.lkml@googlemail.com>

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1030,8 +1030,15 @@ bool radeon_atombios_sideport_present(st
 				      data_offset);
 		switch (crev) {
 		case 1:
-			if (igp_info->info.ucMemoryType & 0xf0)
-				return true;
+			/* AMD IGPS */
+			if ((rdev->family == CHIP_RS690) ||
+			    (rdev->family == CHIP_RS740)) {
+				if (igp_info->info.ulBootUpMemoryClock)
+					return true;
+			} else {
+				if (igp_info->info.ucMemoryType & 0xf0)
+					return true;
+			}
 			break;
 		case 2:
 			if (igp_info->info_2.ucMemoryType & 0x0f)


