Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0LAUiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:38:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19555 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab0LAUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:38:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Dec 2010 12:32:52 -0800
From: Stephen Warren <swarren@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <dahuang@nvidia.com>, <olofj@chromium.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/4] regulator: tps6586x: Handle both enable reg/bits being the same
Date: Wed, 1 Dec 2010 13:37:30 -0700
Message-ID: <1291235851-29523-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
References: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Huang <dahuang@nvidia.com>

Change-Id: I40400bb65eab496bb1becd26b37a9653b99d4f41
Signed-off-by: Danny Huang <dahuang@nvidia.com>
Signed-off-by: Olof Johansson <olofj@chromium.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
  (Split into separate patches)
---
 drivers/regulator/tps6586x-regulator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index effa677..c668944 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -297,6 +297,10 @@ static inline int tps6586x_regulator_preinit(struct device *parent,
 	uint8_t val1, val2;
 	int ret;
 
+	if (ri->enable_reg[0] == ri->enable_reg[1] &&
+	    ri->enable_bit[0] == ri->enable_bit[1])
+			return 0;
+
 	ret = tps6586x_read(parent, ri->enable_reg[0], &val1);
 	if (ret)
 		return ret;
-- 
1.7.0.4
nvpublic

