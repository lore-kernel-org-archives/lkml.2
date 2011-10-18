Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab1JRG0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:26:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34147 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1JRG0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:26:47 -0400
Date: Tue, 18 Oct 2011 09:26:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] gpio-pch: using zero instead of NULL
Message-ID: <20111018062645.GO27732@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4E9D1C26.0203,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse gets cross if you use zero instead of NULL.
drivers/gpio/gpio-pch.c:379:27: warning: Using plain integer as NULL pointer

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 4068084..7ddac42 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -376,7 +376,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 	}
 
 	chip->base = pci_iomap(pdev, 1, 0);
-	if (chip->base == 0) {
+	if (chip->base == NULL) {
 		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
 		ret = -ENOMEM;
 		goto err_iomap;
