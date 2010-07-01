Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab0GAVvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:51:41 -0400
Received: from kroah.org ([198.145.64.141]:60899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab0GAVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:46 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.658403089@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [074/200] drm/radeon/kms: reset ddc_bus in object header parsing
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 2bfcc0fc698d550689ef020c73b2d977b73e728c upstream.

Some LVDS connectors don't have a ddc bus, so reset the
ddc bus to invalid before parsing the next connector
to avoid using stale ddc bus data.  Should fix
fdo bug 28164.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -530,6 +530,8 @@ bool radeon_get_atom_connector_info_from
 			}
 
 			/* look up gpio for ddc, hpd */
+			ddc_bus.valid = false;
+			hpd.hpd = RADEON_HPD_NONE;
 			if ((le16_to_cpu(path->usDeviceTag) &
 			     (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT)) == 0) {
 				for (j = 0; j < con_obj->ucNumberOfObjects; j++) {
@@ -585,9 +587,6 @@ bool radeon_get_atom_connector_info_from
 						break;
 					}
 				}
-			} else {
-				hpd.hpd = RADEON_HPD_NONE;
-				ddc_bus.valid = false;
 			}
 
 			/* needed for aux chan transactions */


