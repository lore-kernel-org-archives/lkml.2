Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1E0JuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:50:12 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:39737 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab1E0JuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:50:10 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] mfd: Use mfd cell platform_data for db8500-prcmu cells platform bits
Date: Fri, 27 May 2011 11:49:43 +0200
Message-ID: <1306489783-16227-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a device platform mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/db8500-prcmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index e637821..02a15d7 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2005,7 +2005,8 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
 static struct mfd_cell db8500_prcmu_devs[] = {
 	{
 		.name = "db8500-prcmu-regulators",
-		.mfd_data = &db8500_regulators,
+		.platform_data = &db8500_regulators,
+		.pdata_size = sizeof(db8500_regulators),
 	},
 	{
 		.name = "cpufreq-u8500",
-- 
1.7.4.3

