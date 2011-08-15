Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1HOKpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:45:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59992 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1HOKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:45:46 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, stable@kernel.org
Subject: [PATCH 2/3] regulator: tps65910: fix list_voltage for VDD1 and VDD2
Date: Mon, 15 Aug 2011 12:45:26 +0200
Message-Id: <1313405127-2724-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit
a320e3c3d6351814afa5182159df88d2637e0f6f (regulator: tps65911: Add new
chip version) which broke list_voltage for VDD1 and VDD2.

Cc: stable@kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index bc5ed25..2c61e48 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -759,6 +759,7 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
 		volt = VDD1_2_MIN_VOLT +
 				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
 	}
-- 
1.7.6

