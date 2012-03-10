Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2CJJA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 04:00:28 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44908 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2CJJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 04:00:24 -0500
Date: Sat, 10 Mar 2012 12:00:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Garzik <jgarzik@pobox.com>, Michael Walle <michael@walle.cc>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] sata_mv: silence an uninitialized variable warning
Message-ID: <20120310090005.GE4647@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090204.4F5B1821.00AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc version 4.6.2-12 complains that if we can't find the "nr-ports"
property in of_property_read_u32_array() then "n_ports" is used
uninitialized.  Let's set it to zero in that case.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index ebd0d24..3d8d5c6 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4026,7 +4026,8 @@ static int mv_platform_probe(struct platform_device *pdev)
 	struct ata_host *host;
 	struct mv_host_priv *hpriv;
 	struct resource *res;
-	int n_ports, rc;
+	int n_ports = 0;
+	int rc;
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
