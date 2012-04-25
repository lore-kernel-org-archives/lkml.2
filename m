Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2DYIrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:47:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44599 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DYIrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:47:18 -0400
Date: Wed, 25 Apr 2012 11:47:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] Extcon: check for allocation failure
Message-ID: <20120425084702.GB12799@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM if the kmalloc() fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 3bc4b8a..fe5a038 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -621,6 +621,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 	}
 
 	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!edev->dev)
+		return -ENOMEM;
 	edev->dev->parent = dev;
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
