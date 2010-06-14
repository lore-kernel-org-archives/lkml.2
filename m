Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0FNOZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:25:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0FNOZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:25:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Date: Mon, 14 Jun 2010 16:23:31 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
References: <20100613203352.GA3577@swordfish> <201006140136.18652.rjw@sisk.pl> <20100614140941.GA3581@swordfish.minsk.epam.com>
In-Reply-To: <20100614140941.GA3581@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141623.31429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010, Sergey Senozhatsky wrote:
> Hello,
> Not sure if this simple solution is the correct one.

Well, let's ask the scheduler people.

Ingo, Peter, what do you think of the patch below?

Rafael


> ---
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index f8b8996..cfb262b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2866,7 +2866,10 @@ unsigned long nr_iowait(void)
>  
>  unsigned long nr_iowait_cpu(void)
>  {
> -	struct rq *this = this_rq();
> +	int cpu = get_cpu();
> +	struct rq *this = cpu_rq(cpu);
> +	put_cpu();
> +	
>  	return atomic_read(&this->nr_iowait);
>  }
>  
