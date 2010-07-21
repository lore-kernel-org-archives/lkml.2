Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab0GUXkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:40:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35567 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065Ab0GUXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:39:59 -0400
Subject: [PATCH 1/5] drivercore/of: Add OF style matching to platform bus
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:39:54 -0600
Message-ID: <20100721233954.7782.81154.stgit@angua>
In-Reply-To: <20100721232817.7782.23410.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the merge between platform bus and of_platform bus, add the
ability to do of-style matching to the platform bus.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org
CC: microblaze-uclinux@itee.uq.edu.au
CC: linuxppc-dev@ozlabs.org
CC: devicetree-discuss@lists.ozlabs.org
---
 drivers/base/platform.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4d99c8b..6a9b3dd 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -12,6 +12,7 @@
 
 #include <linux/string.h>
 #include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
@@ -673,6 +674,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct platform_driver *pdrv = to_platform_driver(drv);
 
+	/* Attempt an OF style match first */
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
 	/* match against the id table first */
 	if (pdrv->id_table)
 		return platform_match_id(pdrv->id_table, pdev) != NULL;

