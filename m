Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936270Ab1KJEFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:05:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965673Ab1KJDpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:02 2011
Message-Id: <20111109213202.270500869@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [198/264] drm/radeon: set hpd polarity at init time so hotplug detect works
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 8ab250d4484b72ccc78e34276c5ffa84c1d41303 upstream.

Polarity needs to be set accordingly to connector status (connected
or disconnected). Set it up at module init so first hotplug works
reliably no matter what is the initial set of connector.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1790,6 +1790,7 @@ radeon_add_atom_connector(struct drm_dev
 			connector->polled = DRM_CONNECTOR_POLL_CONNECT;
 	} else
 		connector->polled = DRM_CONNECTOR_POLL_HPD;
+	radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 
 	connector->display_info.subpixel_order = subpixel_order;
 	drm_sysfs_connector_add(connector);


