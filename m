Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2DDNM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:12:27 -0400
Received: from seven.medozas.de ([188.40.89.202]:55482 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2DDNM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:12:26 -0400
Date: Wed, 4 Apr 2012 15:12:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: gorcunov@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: use more apprioriate types when dumping
 /proc/N/stat
In-Reply-To: <20120322145712.d9efbc34.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1204041511410.2090@frira.zrqbmnf.qr>
References: <1332339136-26022-1-git-send-email-jengelh@medozas.de> <20120322145712.d9efbc34.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-03-22 22:57, Andrew Morton wrote:
>On Wed, 21 Mar 2012 15:12:16 +0100 Jan Engelhardt wrote:
>> @@ -463,8 +463,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>>  	start_time = nsec_to_clock_t(start_time);
>>  
>>  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
>> -%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
>> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
>> +%lu %lu %lu %ld %ld %ld %ld %d %d %d 0 %llu %lu %lu %lu %lu %lu %lu %lu \
>> +%lu %lu %lu %lu %lu %lu 0 0 %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
>>  		pid_nr_ns(pid, ns),
>>  		tcomm,
>>  		state,
>
>When trying to review this I went completely crosseyed then fell on
>the floor.  Which is why this code got ripped out and redone in
>linux-next, against which I'll ask you to redo the patch, please.

>From d066116cdffdeac58815f0417bb8f7ed1dba4433 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@medozas.de>
Date: Mon, 19 Mar 2012 20:28:46 +0100
Subject: [PATCH] procfs: use more apprioriate types when dumping /proc/N/stat

- use int, since task_nice()/task_prio() return that
- field 24: get_mm_rss returns unsigned long

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/proc/array.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index f9bd395..8e27e53 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -361,7 +361,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
-	long priority, nice;
+	int priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
 	char state;
@@ -483,7 +483,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_put_decimal_ull(m, ' ', start_time);
 	seq_put_decimal_ull(m, ' ', vsize);
-	seq_put_decimal_ll(m, ' ', mm ? get_mm_rss(mm) : 0);
+	seq_put_decimal_ull(m, ' ', mm ? get_mm_rss(mm) : 0);
 	seq_put_decimal_ull(m, ' ', rsslim);
 	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->start_code : 1) : 0);
 	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->end_code : 1) : 0);
-- 
1.7.7

