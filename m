Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2GKGgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:36:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47045 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2GKGgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:36:16 -0400
Date: Wed, 11 Jul 2012 09:36:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] Extcon: Arizona: unlock on an error in arizona_micdet()
Message-ID: <20120711063602.GG11812@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains about this.  I don't have a way to test this, but it
does look like we should unlock on error here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index b068bc9..4782884 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -154,6 +154,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
+		mutex_unlock(&info->lock);
 		return IRQ_NONE;
 	}
 
