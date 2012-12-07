Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424220Ab2LGBLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:11:45 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64094 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422698Ab2LGAzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:55:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 05/20] drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()
Date: Thu,  6 Dec 2012 16:54:20 -0800
Message-Id: <20121207005234.353822791@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 804cc4a0ad3a896ca295f771a28c6eb36ced7903 upstream.

The save struct is not initialized previously so explicitly
mark the crtcs as not used when they are not in use.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1164,6 +1164,8 @@ void evergreen_mc_stop(struct radeon_dev
 					break;
 				udelay(1);
 			}
+		} else {
+			save->crtc_enabled[i] = false;
 		}
 	}
 


