Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0DVT13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:29 -0400
Received: from kroah.org ([198.145.64.141]:37107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0DVT12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:28 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:07 2010
Message-Id: <20100422190907.690135384@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Dave Airlie <airlied@redhat.com>
Subject: [003/197] drm: remove the EDID blob stored in the EDID property when it is disconnected
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 725398322d05486109375fbb85c3404108881e17 upstream.

Now the EDID property will be updated when the corresponding EDID can be
obtained from the external display device. But after the external device
is plugged-out, the EDID property is not updated. In such case we still
get the corresponding EDID property although it is already detected as
disconnected.

https://bugs.freedesktop.org/show_bug.cgi?id=26743

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_crtc_helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -104,6 +104,7 @@ int drm_helper_probe_single_connector_mo
 	if (connector->status == connector_status_disconnected) {
 		DRM_DEBUG_KMS("%s is disconnected\n",
 			  drm_get_connector_name(connector));
+		drm_mode_connector_update_edid_property(connector, NULL);
 		goto prune;
 	}
 


