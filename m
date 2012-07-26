Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2GZRir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:38:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:45654 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2GZRiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:38:46 -0400
Message-ID: <501180A1.1000504@linutronix.de>
Date: Thu, 26 Jul 2012 19:38:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
 did it
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 05:20 PM, Sebastian Andrzej Siewior wrote:
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index f935327..772eb3a 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1528,7 +1528,10 @@ static void handle_swbp(struct pt_regs *regs)
>
>   	utask->state = UTASK_SSTEP;
>   	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
> -		user_enable_single_step(current);
> +		if (test_tsk_thread_flag(current, TIF_SINGLESTEP))
> +			uprobe->flags |= UPROBE_USER_SSTEP;
> +		else
> +			user_enable_single_step(current);

After looking at it for a bit I noticed that the state should be saved
in utask intead of uprobe because uprobe might be shared with another
task.
I would resend the fixed patch unless someone comes up with something
else..

Sebastian
