Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1L2JDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 04:03:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56138 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1L2JD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 04:03:27 -0500
Message-ID: <1325149400.7012.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: Fix checking return value of create_regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Dec 2011 17:03:20 +0800
In-Reply-To: <1325149328.7012.1.camel@phoenix>
References: <1325149328.7012.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_regulator() returns NULL on fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fb6ea9b..5e43906 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -985,9 +985,8 @@ static int set_supply(struct regulator_dev *rdev,
 	rdev_info(rdev, "supplied by %s\n", rdev_get_name(supply_rdev));
 
 	rdev->supply = create_regulator(supply_rdev, &rdev->dev, "SUPPLY");
-	if (IS_ERR(rdev->supply)) {
-		err = PTR_ERR(rdev->supply);
-		rdev->supply = NULL;
+	if (rdev->supply == NULL) {
+		err = -ENOMEM;
 		return err;
 	}
 
-- 
1.7.5.4



