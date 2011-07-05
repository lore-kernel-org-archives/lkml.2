Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab1GEKx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:53:57 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:49244
	"EHLO CH1EHSOBE016.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755583Ab1GEKx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:53:56 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h944h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNUWXS-01-QP6-02
X-M-MSG: 
Date: Tue, 5 Jul 2011 12:53:50 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: Extend attr check to allow also dynamically generated
 types
Message-ID: <20110705105350.GC4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110704175927.GZ4590@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resent with fixed subject)

On 04.07.11 19:59:27, Robert Richter wrote:
> (Btw, current kernel code does not support dynamically allocated pmu
> types due to a check in perf_copy_attr():
> 
>         if (attr->type >= PERF_TYPE_MAX)
>                 return -EINVAL;
> )

Below a fix for this.

-Robert


>From 63e76c3d827e3d6d24ff4ee24854523c054c7179 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 5 Jul 2011 11:04:39 +0200
Subject: [PATCH] perf: Extend attr check to allow also dynamically generated
 types

When attaching events to a pmu with generated type, the initialization
fails. Extending the check to allow such types.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cca3588..5900729 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5958,7 +5958,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	 * If the type exists, the corresponding creation will verify
 	 * the attr->config.
 	 */
-	if (attr->type >= PERF_TYPE_MAX)
+	if (attr->type >= PERF_TYPE_MAX && !idr_find(&pmu_idr, attr->type))
 		return -EINVAL;
 
 	if (attr->__reserved_1)
-- 
1.7.5.3




-- 
Advanced Micro Devices, Inc.
Operating System Research Center

