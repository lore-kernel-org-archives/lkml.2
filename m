Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab0HXXDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:42 -0400
Received: from kroah.org ([198.145.64.141]:32813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933664Ab0HXXDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:31 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:09 2010
Message-Id: <20100824224509.494036626@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [095/114] drm/radeon/kms: fix sideport detection on newer rs880 boards
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4b80d954a7e54c13a5063af18d01719ad6a0daf3 upstream.

The meaning of ucMemoryType changed on recent boards, however,
ulBootUpSidePortClock should be set properly across all boards.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1059,7 +1059,7 @@ bool radeon_atombios_sideport_present(st
 			}
 			break;
 		case 2:
-			if (igp_info->info_2.ucMemoryType & 0x0f)
+			if (igp_info->info_2.ulBootUpSidePortClock)
 				return true;
 			break;
 		default:


