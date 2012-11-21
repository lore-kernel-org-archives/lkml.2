Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2KUHYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:24:52 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:46582 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2KUHYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:24:51 -0500
Date: Wed, 21 Nov 2012 00:24:48 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] of: Have of_device_add call platform_device_add rather
 than device_add
Message-ID: <20121121072448.GG19837@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows platform_device_add a chance to call insert_resource
on all of the resources from OF. At a minimum this fills in proc/iomem
and presumably makes resource tracking and conflict detection work
better.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/of/device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Tested on PPC32 and ARM32 embedded kernels.

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 4c74e4f..a5b67dc 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -62,7 +62,7 @@ int of_device_add(struct platform_device *ofdev)
 	if (!ofdev->dev.parent)
 		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
 
-	return device_add(&ofdev->dev);
+	return platform_device_add(ofdev);
 }
 
 int of_device_register(struct platform_device *pdev)
-- 
1.7.4.1

