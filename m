Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2JBNEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:04:50 -0400
Received: from rain.florz.de ([62.216.164.86]:48408 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753479Ab2JBNEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:04:49 -0400
X-Greylist: delayed 2645 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 09:04:49 EDT
Date: Tue, 2 Oct 2012 14:20:37 +0200
From: Florian Zumbiehl <florz@florz.de>
To: airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/savage: re-add busmaster enable, regression fix
Message-ID: <20121002122036.GN1162@florz.florz.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

466e69b8b03b8c1987367912782bc12988ad8794 dropped busmaster enable from the
global drm code and moved it to the individual drivers, but missed the savage
driver. So, this re-adds busmaster enable to the savage driver, fixing the
regression.

Signed-off-by: Florian Zumbiehl <florz@florz.de>

diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index 6eb507a..7d3f0f0 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -547,6 +547,8 @@ int savage_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	dev_priv->chipset = (enum savage_family)chipset;
 
+	pci_set_master(dev->pdev);
+
 	return 0;
 }
 
