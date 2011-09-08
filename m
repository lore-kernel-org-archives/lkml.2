Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1IHE64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 00:58:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56632 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754705Ab1IHE6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 00:58:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+hi7hJB2+hj61jpAbKfSq9dTEIxHCbvVkdAtG7VP
	OO6jFfQtzLpkib
Subject: Re: [patch] sched, rt: fix migrate_enable() thinko
From: Mike Galbraith <efault@gmx.de>
To: frank.rowand@am.sony.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <4E68243C.7000404@am.sony.com>
References: <1313232790.25267.7.camel@twins>
	 <1314108763.6689.4.camel@marge.simson.net>  <4E68243C.7000404@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Sep 2011 06:58:45 +0200
Message-ID: <1315457925.10591.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 19:11 -0700, Frank Rowand wrote:

> Fix compile error for CONFIG_SMP=n

Guilty as charged you honor.

Acked-by: Mike Galbraith <efault@gmx.de>

> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> ---
>  kernel/sched_debug.c |    2 	2 +	0 -	0 !
>  1 file changed, 2 insertions(+)
> 
> Index: b/kernel/sched_debug.c
> ===================================================================
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -235,7 +235,9 @@ void print_rt_rq(struct seq_file *m, int
>  	P(rt_throttled);
>  	PN(rt_time);
>  	PN(rt_runtime);
> +#ifdef CONFIG_SMP
>  	P(rt_nr_migratory);
> +#endif
>  
>  #undef PN
>  #undef P
> 


