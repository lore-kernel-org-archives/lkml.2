Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1IHXhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:37:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47542 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755071Ab1IHXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:37:09 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Philip Rakity <prakity@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Clarify documentation for regulator-regulator supplies
Date: Thu,  8 Sep 2011 10:41:33 -0700
Message-Id: <1315503693-3785-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315503693-3785-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1315503693-3785-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mechanism used for connecting regulators together when one regulator
supplies another wasn't clear as the names being used weren't really tied
together well.

Reported-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/machine.txt |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index 311c61f..ce63af0 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -43,6 +43,7 @@ to their supply regulator :-
 
 static struct regulator_init_data regulator1_data = {
 	.constraints = {
+		.name = "Regulator-1",
 		.min_uV = 3300000,
 		.max_uV = 3300000,
 		.valid_modes_mask = REGULATOR_MODE_NORMAL,
@@ -51,13 +52,19 @@ static struct regulator_init_data regulator1_data = {
 	.consumer_supplies = regulator1_consumers,
 };
 
+The name field should be set to something that is usefully descriptive
+for the board for configuration of supplies for other regulators and
+for use in logging and other diagnostic output.  Normally the name
+used for the supply rail in the schematic is a good choice.  If no
+name is provided then the subsystem will choose one.
+
 Regulator-1 supplies power to Regulator-2. This relationship must be registered
 with the core so that Regulator-1 is also enabled when Consumer A enables its
 supply (Regulator-2). The supply regulator is set by the supply_regulator
-field below:-
+field below and co:-
 
 static struct regulator_init_data regulator2_data = {
-	.supply_regulator = "regulator_name",
+	.supply_regulator = "Regulator-1",
 	.constraints = {
 		.min_uV = 1800000,
 		.max_uV = 2000000,
-- 
1.7.5.4

