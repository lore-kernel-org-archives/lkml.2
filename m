Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2C0UWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 16:22:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24795 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2C0UW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:22:28 -0400
Date: Tue, 27 Mar 2012 23:22:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Marek Vasut <marek.vasut@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] isp1704_charger: use after free on probe error
Message-ID: <20120327202212.GB9197@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F72217F.006D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't use "isp" after freeing it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 39eb50f..e5ccd29 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -474,13 +474,13 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 fail2:
 	power_supply_unregister(&isp->psy);
 fail1:
+	isp1704_charger_set_power(isp, 0);
 	usb_put_transceiver(isp->phy);
 fail0:
 	kfree(isp);
 
 	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
 
-	isp1704_charger_set_power(isp, 0);
 	return ret;
 }
 
