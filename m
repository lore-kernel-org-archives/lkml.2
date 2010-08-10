Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0HJKF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:05:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:44019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0HJKFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:05:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,347,1278313200"; 
   d="scan'208";a="826267252"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] Fix the argument order to intel_scu_ipc_command in the
	battery driver
To: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Aug 2010 10:27:57 +0100
Message-ID: <20100810092756.1814.68243.stgit@localhost.localdomain>
In-Reply-To: <20100810092700.1814.11982.stgit@localhost.localdomain>
References: <20100810092700.1814.11982.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

The arguments to intel_scu_ipc_command are "command, subcommand"
the battery driver got this the wrong way around.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/intel_mid_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index 46730f5..6430a7b 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -168,7 +168,7 @@ struct battery_property {
  */
 static int pmic_scu_ipc_battery_cc_read(u32 *value)
 {
-	return intel_scu_ipc_command(IPC_CMD_CC_RD, IPCMSG_BATTERY,
+	return intel_scu_ipc_command(IPCMSG_BATTERY, IPC_CMD_CC_RD,
 					NULL, 0, value, 1);
 }
 

