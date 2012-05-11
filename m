Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946329Ab2EKW34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:29:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab2EKW3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:29:54 -0400
From: "Herton R. Krzesinski" <herton.krzesinski@canonical.com>
To: spi-devel-general@lists.sourceforge.net
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control
Date: Fri, 11 May 2012 15:29:50 -0700
Message-Id: <1336775390-24128-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

Commit 178db7d3, "spi: Fix device unregistration when unregistering
the bus master", changed spi device initialization of dev.parent pointer
to be the master's device pointer instead of his parent.

This introduced a bug in spi-fsl-spi, since its usage of spi device
pointer was not updated accordingly. This was later fixed by commit
5039a86, "spi/mpc83xx: fix NULL pdata dereference bug", but it missed
another spot on fsl_spi_cs_control function where we also need to update
usage of spi device pointer. This change address that.

Cc: stable@vger.kernel.org
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/spi/spi-fsl-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 5f748c0..6a62934 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -933,7 +933,7 @@ err:
 
 static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 {
-	struct device *dev = spi->dev.parent;
+	struct device *dev = spi->dev.parent->parent;
 	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
 	u16 cs = spi->chip_select;
 	int gpio = pinfo->gpios[cs];
-- 
1.7.9.5

