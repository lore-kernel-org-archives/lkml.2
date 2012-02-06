Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2BFQSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:18:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50983 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab2BFQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:17:26 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com,
        Andi Kleen <ak@linux.intel.com>, jbarnes@virtuousgeek.org
Subject: [PATCH 5/5] Disable MCP limit exceeded messages from Intel IPS driver
Date: Mon,  6 Feb 2012 08:17:12 -0800
Message-Id: <1328545032-21373-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On a system on the thermal limit these are quite noisy and flood the logs.
Better would be a counter anyways. But given that we don't even have
anything for normal throttling this doesn't seem to be urgent either.

Cc: jbarnes@virtuousgeek.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/platform/x86/intel_ips.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 809a3ae..84bba52 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -620,25 +620,16 @@ static bool mcp_exceeded(struct ips_driver *ips)
 	bool ret = false;
 	u32 temp_limit;
 	u32 avg_power;
-	const char *msg = "MCP limit exceeded: ";
 
 	spin_lock_irqsave(&ips->turbo_status_lock, flags);
 
 	temp_limit = ips->mcp_temp_limit * 100;
-	if (ips->mcp_avg_temp > temp_limit) {
-		dev_info(&ips->dev->dev,
-			"%sAvg temp %u, limit %u\n", msg, ips->mcp_avg_temp,
-			temp_limit);
+	if (ips->mcp_avg_temp > temp_limit)
 		ret = true;
-	}
 
 	avg_power = ips->cpu_avg_power + ips->mch_avg_power;
-	if (avg_power > ips->mcp_power_limit) {
-		dev_info(&ips->dev->dev,
-			"%sAvg power %u, limit %u\n", msg, avg_power,
-			ips->mcp_power_limit);
+	if (avg_power > ips->mcp_power_limit)
 		ret = true;
-	}
 
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
-- 
1.7.7

