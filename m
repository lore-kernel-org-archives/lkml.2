Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2E1D3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52179 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab2E1D3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:42 -0400
Message-Id: <20120528031216.101299517@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 096/117] spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 067aa4815a9bc12a569d8a06afef50ba5773afbf upstream.

Commit 178db7d3, "spi: Fix device unregistration when unregistering
the bus master", changed spi device initialization of dev.parent pointer
to be the master's device pointer instead of his parent.

This introduced a bug in spi-fsl-spi, since its usage of spi device
pointer was not updated accordingly. This was later fixed by commit
5039a86, "spi/mpc83xx: fix NULL pdata dereference bug", but it missed
another spot on fsl_spi_cs_control function where we also need to update
usage of spi device pointer. This change address that.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


