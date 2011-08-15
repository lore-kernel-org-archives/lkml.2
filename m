Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1HOKpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:45:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65081 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1HOKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:45:46 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, stable@kernel.org
Subject: [PATCH 1/3] regulator: tps65910: fix device initialisation
Date: Mon, 15 Aug 2011 12:45:25 +0200
Message-Id: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit
a320e3c3d6351814afa5182159df88d2637e0f6f (regulator: tps65911: Add new
chip version) which broke probe for all devices:

	"Invalid tps chip version"

Cc: stable@kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 55dd4e6..bc5ed25 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -898,9 +898,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	case TPS65910:
 		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
 		info = tps65910_regs;
+		break;
 	case TPS65911:
 		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
 		info = tps65911_regs;
+		break;
 	default:
 		pr_err("Invalid tps chip version\n");
 		return -ENODEV;
-- 
1.7.6

