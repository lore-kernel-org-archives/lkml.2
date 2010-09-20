Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0ITTQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:16:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab0ITTQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:16:01 -0400
Date: Mon, 20 Sep 2010 12:14:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH 2/2] kernel: extract thread types from
 task_struct::flags
Message-Id: <20100920121446.18fb3a65.akpm@linux-foundation.org>
In-Reply-To: <20100920151839.414197086@chello.nl>
References: <20100920151334.569154707@chello.nl>
	<20100920151839.414197086@chello.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 17:13:36 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Free up a few more PF_flags by moving thread types out to their own variable.
> 
> Initially I compressed the types into less bits inside task_struct::flags, but
> Thomas suggested I move them to their own field.
> 

There doesn't seem to be a huge point to all this, but I guess there's
some sense in separating "what type of thread this is" from "attributes
of this thread".  Maybe.  At the expense of a larger task_struct.

> +/*
> + * Types >= tt_kernel imply the old PF_KTHREAD
> + */

Perhaps that should be encapsulated into another helper function

> --- linux-2.6.orig/kernel/fork.c
> +++ linux-2.6/kernel/fork.c
> @@ -570,7 +570,7 @@ struct mm_struct *get_task_mm(struct tas
>  	task_lock(task);
>  	mm = task->mm;
>  	if (mm) {
> -		if (task->flags & PF_KTHREAD)
> +		if (task_type(task) >= tt_kernel)

rather than open-coded everywhere.


