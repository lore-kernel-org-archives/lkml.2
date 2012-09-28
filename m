Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222Ab2I1THV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:07:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54594 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030843Ab2I1THI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:07:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 260/262] drm/udl: limit modes to the sku pixel limits.
Date: Fri, 28 Sep 2012 11:53:09 -0700
Message-Id: <20120928183029.233880497@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 3a75885848996baab5276ff37ebf7295c3c753f0 upstream.

Otherwise when X starts we commonly get a black screen scanning
out nothing, its wierd dpms on/off from userspace brings it back,

With this on F18, multi-seat works again with my 1920x1200 monitor
which is above the sku limit for the device I have.

Reviewed-by: Alex Deucher <alexander.deucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_connector.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -69,6 +69,13 @@ static int udl_get_modes(struct drm_conn
 static int udl_mode_valid(struct drm_connector *connector,
 			  struct drm_display_mode *mode)
 {
+	struct udl_device *udl = connector->dev->dev_private;
+	if (!udl->sku_pixel_limit)
+		return 0;
+
+	if (mode->vdisplay * mode->hdisplay > udl->sku_pixel_limit)
+		return MODE_VIRTUAL_Y;
+
 	return 0;
 }
 


