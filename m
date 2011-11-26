Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1KZMTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 07:19:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46723 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1KZMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 07:19:30 -0500
Message-ID: <1322309959.6001.1.camel@phoenix>
Subject: [PATCH] regulator: Checking return value of
 of_get_regulator_init_data
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 26 Nov 2011 20:19:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_regulator_init_data() may return NULL, thus
check the return value to avoid NULL pointer dereference.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/fixed.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 716ea37..639e19d 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -64,6 +64,9 @@ struct fixed_voltage_config *of_get_fixed_voltage_config(struct device *dev)
 		return NULL;
 
 	config->init_data = of_get_regulator_init_data(dev);
+	if (!config->init_data)
+		return NULL;
+
 	init_data = config->init_data;
 
 	config->supply_name = init_data->constraints.name;
-- 
1.7.5.4



