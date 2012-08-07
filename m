Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2HGXIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:08:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38529 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab2HGWjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 060/109] drm/radeon: fix non revealent error message
Date: Tue,  7 Aug 2012 15:35:19 -0700
Message-Id: <20120807222048.359840304@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 8d1c702aa0b2c4b22b0742b72a1149d91690674b upstream.

We want to print link status query failed only if it's
an unexepected fail. If we query to see if we need
link training it might be because there is nothing
connected and thus link status query have the right
to fail in that case.

To avoid printing failure when it's expected, move the
failure message to proper place.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -22,6 +22,7 @@
  *
  * Authors: Dave Airlie
  *          Alex Deucher
+ *          Jerome Glisse
  */
 #include "drmP.h"
 #include "radeon_drm.h"
@@ -637,7 +638,6 @@ static bool radeon_dp_get_link_status(st
 	ret = radeon_dp_aux_native_read(radeon_connector, DP_LANE0_1_STATUS,
 					link_status, DP_LINK_STATUS_SIZE, 100);
 	if (ret <= 0) {
-		DRM_ERROR("displayport link status failed\n");
 		return false;
 	}
 
@@ -816,8 +816,10 @@ static int radeon_dp_link_train_cr(struc
 		else
 			mdelay(dp_info->rd_interval * 4);
 
-		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status))
+		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status)) {
+			DRM_ERROR("displayport link status failed\n");
 			break;
+		}
 
 		if (dp_clock_recovery_ok(dp_info->link_status, dp_info->dp_lane_count)) {
 			clock_recovery = true;
@@ -879,8 +881,10 @@ static int radeon_dp_link_train_ce(struc
 		else
 			mdelay(dp_info->rd_interval * 4);
 
-		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status))
+		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status)) {
+			DRM_ERROR("displayport link status failed\n");
 			break;
+		}
 
 		if (dp_channel_eq_ok(dp_info->link_status, dp_info->dp_lane_count)) {
 			channel_eq = true;


