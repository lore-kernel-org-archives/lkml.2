Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab0GAWNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:13:25 -0400
Received: from kroah.org ([198.145.64.141]:47421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab0GAUuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:07 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:31 2010
Message-Id: <20100701173431.545487365@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 056/164] drm/radeon/kms: reset ddc_bus in object header parsing
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

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
@@ -514,6 +514,8 @@ bool radeon_get_atom_connector_info_from
 			}
 
 			/* look up gpio for ddc, hpd */
+			ddc_bus.valid = false;
+			hpd.hpd = RADEON_HPD_NONE;
 			if ((le16_to_cpu(path->usDeviceTag) &
 			     (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT)) == 0) {
 				for (j = 0; j < con_obj->ucNumberOfObjects; j++) {
@@ -569,9 +571,6 @@ bool radeon_get_atom_connector_info_from
 						break;
 					}
 				}
-			} else {
-				hpd.hpd = RADEON_HPD_NONE;
-				ddc_bus.valid = false;
 			}
 
 			conn_id = le16_to_cpu(path->usConnObjectId);


