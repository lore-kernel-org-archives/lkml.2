Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031260Ab2CVV5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:57:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030938Ab2CVV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:57:14 -0400
Date: Thu, 22 Mar 2012 14:57:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: gorcunov@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: use more apprioriate types when dumping
 /proc/N/stat
Message-Id: <20120322145712.d9efbc34.akpm@linux-foundation.org>
In-Reply-To: <1332339136-26022-1-git-send-email-jengelh@medozas.de>
References: <1332339136-26022-1-git-send-email-jengelh@medozas.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 15:12:16 +0100
Jan Engelhardt <jengelh@medozas.de> wrote:

> * field 14, 15: clock_t is a long
> * field 18, 19: task_nice/task_prio return int
> * field 24: get_mm_rss returns unsigned long
> * field 36, 37: always 0
> 
> ...
>
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -361,7 +361,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  			struct pid *pid, struct task_struct *task, int whole)
>  {
>  	unsigned long vsize, eip, esp, wchan = ~0UL;
> -	long priority, nice;
> +	int priority, nice;
>  	int tty_pgrp = -1, tty_nr = 0;
>  	sigset_t sigign, sigcatch;
>  	char state;
> @@ -463,8 +463,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  	start_time = nsec_to_clock_t(start_time);
>  
>  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
> -%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
> +%lu %lu %lu %ld %ld %ld %ld %d %d %d 0 %llu %lu %lu %lu %lu %lu %lu %lu \
> +%lu %lu %lu %lu %lu %lu 0 0 %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
>  		pid_nr_ns(pid, ns),
>  		tcomm,
>  		state,
> @@ -503,8 +503,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  		sigign      .sig[0] & 0x7fffffffUL,
>  		sigcatch    .sig[0] & 0x7fffffffUL,
>  		wchan,
> -		0UL,
> -		0UL,
>  		task->exit_signal,
>  		task_cpu(task),
>  		task->rt_priority,

When trying to review this I went completely crosseyed then fell on
the floor.  Which is why this code got ripped out and redone in
linux-next, against which I'll ask you to redo the patch, please.


