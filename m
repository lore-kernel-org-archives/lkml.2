Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2ADQLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:11:01 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17545 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2ADQK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:10:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jan 2012 08:10:59 -0800
From: Laxman Dewangan <ldewangan.com@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] regulator: fixed: Move drivers to subsys_initcall_sync()
Date: Wed,  4 Jan 2012 21:38:55 +0530
Message-Id: <1325693335-1905-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

The fixed regulator is used to enable/disable rails which are
mainly controlled by the switch. The switches are toggled by
gpio apis.
The switches are connected through on-chip gpios or through
external devices' gpios like mfd, i2c based gpio expander etc.
The registration of the fixed regulator get success only if the
required gpios are already available in the system at this time.
The on-chip gpios are available till this time as on-chip gpios
are initialized in arch_init(). But external peripheral's gpios
may not be available at this time as they get initialized as part
of subsys_initcall() and due to this registration of the fixed
regulator may fails.
Moving the driver to subsys_initcall_sync() will make sure that
all gpios i.e. on-chip gpios as well as external peripheral's gpios
are available before fixed regulator registration.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/fixed.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index a44a017..baec76e 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -307,7 +307,7 @@ static int __init regulator_fixed_voltage_init(void)
 {
 	return platform_driver_register(&regulator_fixed_voltage_driver);
 }
-subsys_initcall(regulator_fixed_voltage_init);
+subsys_initcall_sync(regulator_fixed_voltage_init);
 
 static void __exit regulator_fixed_voltage_exit(void)
 {
-- 
1.7.1.1

