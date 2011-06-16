Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1FPUPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:15:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27663 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab1FPUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:14:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, cpufreq@vger.kernel.org,
        davej@redhat.com, bp@alien8.de, Mark.Langsdorf@amd.com,
        andre.przywara@amd.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] [CPUFREQ] powernow-k8: Don't try to transition if the pstate is incorrect
Date: Thu, 16 Jun 2011 15:36:40 -0400
Message-Id: <1308253000-6289-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308253000-6289-1-git-send-email-konrad.wilk@oracle.com>
References: <1308253000-6289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DFA6422.006A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch augments the pstate transition code to error out
(instead of returning 0) when an incorrect pstate is provided.

Suggested-by: Borislav Petkov <bp@alien8.de>
CC: andre.przywara@amd.com
CC: Mark.Langsdorf@amd.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/cpufreq/powernow-k8.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 287c56f..bce576d 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1104,7 +1104,8 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
 	/* get MSR index for hardware pstate transition */
 	pstate = index & HW_PSTATE_MASK;
 	if (pstate > data->max_hw_pstate)
-		return 0;
+		return -EINVAL;
+
 	freqs.old = find_khz_freq_from_pstate(data->powernow_table,
 			data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
-- 
1.7.4.1

