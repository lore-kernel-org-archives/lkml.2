Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2KQFRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:17:14 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44887 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2KQFRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:17:13 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 13:17:13 +0800
Message-ID: <CAJd=RBC0WiAAOYpZ+wdR1wBLosKNPJWzYd6P+S6hjYYx8k652w@mail.gmail.com>
Subject: [PATCH 3/5] balancenuma: cleanup in resetting numa scan
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking ->mm is not needed, but too late if necessary.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/fair.c	Sat Nov 17 12:12:08 2012
+++ b/kernel/sched/fair.c	Sat Nov 17 12:14:26 2012
@@ -1125,7 +1125,7 @@ static void reset_ptenuma_scan(struct ta
 	ACCESS_ONCE(p->mm->numa_scan_seq)++;
 	p->mm->numa_scan_offset = 0;
 	
-	if (p->mm && p->mm->mm_balancenuma)
+	if (p->mm->mm_balancenuma)
 		p->mm->mm_balancenuma->mm_numa_fault_tot >>= 1;
 	if (p->task_balancenuma) {
 		int nid;
--
