Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2DYHV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:21:56 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:50517 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2DYHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:21:55 -0400
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <201204250721.q3P7LmQN009128@gatekeeper.vosshq.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Wed, 25 Apr 2012 08:59:03 +0200
Subject: [PATCH] drivers/power/sbs-battery.c: capacity attr = remaining
 relative capacity
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, rklein@nvidia.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the capacity exported by this driver refers to reg 0x0e,
which is the absolute state of charge which according to SBS
refers to the design capacity/ energy of the battery. It can be
> 100 % and drops below 100 % for a fully charged battery with
the battery aging.

This is not what the user exspects of a remaining capacity
indication between 0 and 100 % with 100 % referring to
a fully charged battery. This is provided by SBS reg 0x0d,
which is the relative state of charge referring to the
full charge capacity.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/power/sbs-battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 9ff8af0..182d2ed 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -89,7 +89,7 @@ static const struct chip_data {
 	[REG_CURRENT] =
 		SBS_DATA(POWER_SUPPLY_PROP_CURRENT_NOW, 0x0A, -32768, 32767),
 	[REG_CAPACITY] =
-		SBS_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
+		SBS_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0D, 0, 100),
 	[REG_REMAINING_CAPACITY] =
 		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
 	[REG_REMAINING_CAPACITY_CHARGE] =
-- 
1.7.5.4

