Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2A1LAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 06:00:43 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45939 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2A1LAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 06:00:42 -0500
Date: Sat, 28 Jan 2012 12:00:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] x86, dumpstack: removed unneeded check in dump_trace()
Message-ID: <20120128110034.GD3391@somewhere>
References: <20120128105246.GA25092@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120128105246.GA25092@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 01:52:46PM +0300, Dan Carpenter wrote:
> Smatch complains that we have some inconsistent NULL checking.  If
> "task" were NULL then it would lead to a NULL dereference later.  We
> can remove this test because earlier on in the function we have:
> 	if (!task)
> 		task = current;
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> 
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 6d728d9..af7785f 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -129,7 +129,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
>  	if (!stack) {
>  		if (regs)
>  			stack = (unsigned long *)regs->sp;
> -		else if (task && task != current)
> +		else if (task != current)
>  			stack = (unsigned long *)task->thread.sp;
>  		else
>  			stack = &dummy;
