Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2LNU6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:58:00 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:6622 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932309Ab2LNU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:57:59 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MF1GWA-02-1GI-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <rric@kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <suravee.suthikulpanit@amd.com>, <jacob.shin@amd.com>
Subject: [PATCH 1/1] Change IBS PMU to use perf_hw_context
Date: Fri, 14 Dec 2012 14:57:42 -0600
Message-ID: <1355518662-32071-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Currently, the AMD IBS PMU initialize pmu.task_ctx_nr to perf_invalid_context
which only allows IBS to be running only in system-wide mode (e.g. perf record -a).
IBS hardware is available in each core and should be per-context.  
This patch modifies the task_ctx_nr to use the perf_hw_context (default) instead.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 6336bcb..08fa71a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -466,8 +466,6 @@ static struct attribute *ibs_op_format_attrs[] = {
 
 static struct perf_ibs perf_ibs_fetch = {
 	.pmu = {
-		.task_ctx_nr	= perf_invalid_context,
-
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
@@ -490,8 +488,6 @@ static struct perf_ibs perf_ibs_fetch = {
 
 static struct perf_ibs perf_ibs_op = {
 	.pmu = {
-		.task_ctx_nr	= perf_invalid_context,
-
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
-- 
1.7.10.4


