Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0KWOqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:46:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0KWOqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:46:08 -0500
Date: Tue, 23 Nov 2010 15:39:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] cpu: Remove incorrect BUG_ON
Message-ID: <20101123143910.GA31502@redhat.com>
References: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, tip-bot for Peter Zijlstra wrote:
>
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -249,8 +249,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  	 * The migration_call() CPU_DYING callback will have removed all
>  	 * runnable tasks from the cpu, there's only the idle task left now
>  	 * that the migration thread is done doing the stop_machine thing.
> +	 *
> +	 * Wait for the stop thread to go away.
>  	 */
> -	BUG_ON(!idle_cpu(cpu));
> +	while (!idle_cpu(cpu))
> +		cpu_relax();

Yes... but I still can't understand why should we wait at all.

Peter, I am just curious, help ;)

Oleg.

