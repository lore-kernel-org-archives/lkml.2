Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1EILVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:21:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:20799 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1EILVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:21:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,340,1301900400"; 
   d="scan'208";a="690079012"
Date: Mon, 9 May 2011 13:21:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/19] mfd: Add platform data pointer back
Message-ID: <20110509112107.GC8071@sortiz-mobl>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-2-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304901131-7104-2-git-send-email-sameo@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we have a way to pass MFD cells down to the sub drivers,
we can gradually get rid of mfd_data by putting the platform pointer
back in place.

Cc: Andres Salomon <dilinger@queued.net>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/mfd-core.c   |    7 +++++++
 include/linux/mfd/core.h |    4 ++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f4c8c84..0902523 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -88,6 +88,13 @@ static int mfd_add_device(struct device *parent, int id,
 
 	pdev->dev.parent = parent;
 
+	if (cell->pdata_size) {
+		ret = platform_device_add_data(pdev,
+					cell->platform_data, cell->pdata_size);
+		if (ret)
+			goto fail_res;
+	}
+
 	ret = mfd_platform_add_cell(pdev, cell);
 	if (ret)
 		goto fail_res;
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index aef23309..68c13e5 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -36,6 +36,10 @@ struct mfd_cell {
 	/* mfd_data can be used to pass data to client drivers */
 	void			*mfd_data;
 
+	/* platform data passed to the sub devices drivers */
+	void			*platform_data;
+	size_t			pdata_size;
+
 	/*
 	 * These resources can be specified relative to the parent device.
 	 * For accessing hardware you should use resources from the platform dev
-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
