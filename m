Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2HRRba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:61057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab2HRRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354047"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/31] sections: Fix section conflicts in drivers/hwmon
Date: Sat, 18 Aug 2012 10:30:05 -0700
Message-Id: <1345311022-26328-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/coretemp.c |    2 +-
 drivers/hwmon/w83627hf.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index faa16f8..0fa356f 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -196,7 +196,7 @@ struct tjmax {
 	int tjmax;
 };
 
-static struct tjmax __cpuinitconst tjmax_table[] = {
+static const struct tjmax __cpuinitconst tjmax_table[] = {
 	{ "CPU D410", 100000 },
 	{ "CPU D425", 100000 },
 	{ "CPU D510", 100000 },
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index ab48252..5b1a6a6 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -1206,7 +1206,7 @@ static int __init w83627hf_find(int sioaddr, unsigned short *addr,
 	int err = -ENODEV;
 	u16 val;
 
-	static const __initdata char *names[] = {
+	static __initconst char *const names[] = {
 		"W83627HF",
 		"W83627THF",
 		"W83697HF",
-- 
1.7.7.6

