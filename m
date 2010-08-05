Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab0HELko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:40:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab0HELkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:40:42 -0400
Subject: Re: [PATCH] stop_machine: struct cpu_stopper, remove alignment
 padding on 64 bits
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1281006717.2000.12.camel@castor.rsk>
References: <1281006717.2000.12.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 05 Aug 2010 13:40:35 +0200
Message-ID: <1281008435.1923.1820.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 12:11 +0100, Richard Kennedy wrote:
> Reorder elements in structure cpu_stopper to remove alignment padding on
> 64 bit builds, this shrinks its size from 40 to 32 bytes saving 8 bytes
> per cpu.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Looks good to me. Tejun will you take it or should I send it Ingo wards?

> ---
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 70f8d90..4372ccb 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -35,9 +35,9 @@ struct cpu_stop_done {
>  /* the actual stopper, one per every possible cpu, enabled on online cpus */
>  struct cpu_stopper {
>  	spinlock_t		lock;
> +	bool			enabled;	/* is this stopper enabled? */
>  	struct list_head	works;		/* list of pending works */
>  	struct task_struct	*thread;	/* stopper thread */
> -	bool			enabled;	/* is this stopper enabled? */
>  };
>  
>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
> 
> 


