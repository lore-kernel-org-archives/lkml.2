Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2CUHxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:53:17 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4145 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab2CUHxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:53:15 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
From: "Michael J. Wang" <mjwang@broadcom.com>
To: "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>
cc: "Yong Zhang" <yong.zhang0@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael J. Wang" <mjwang@broadcom.com>
Subject: [RESEND PATCH v2 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Topic: [RESEND PATCH v2 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Index: Ac0HN5/pkNYFLZFeQPK0Y7cjQti9Pw==
Date: Wed, 21 Mar 2012 07:52:57 +0000
Message-ID: <2EF88150C0EF2C43A218742ED384C1BC0FC8439E@IRVEXCHMB08.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.253.161]
MIME-Version: 1.0
X-WSS-ID: 637754823E07268120-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael J Wang <mjwang@broadcom.com>

Avoid extra work by skipping rt_rq's whose max prio is equal to next->prio

Signed-off-by: Michael J Wang <mjwang@broadcom.com>

--- 

--- linux-3.3/kernel/sched/rt.c.orig	2012-03-18 16:15:34.000000000 -0700
+++ linux-3.3/kernel/sched/rt.c	2012-03-19 14:52:54.585391702 -0700
@@ -1403,7 +1403,7 @@
 next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
-		if (next && next->prio < idx)
+		if (next && next->prio <= idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;


