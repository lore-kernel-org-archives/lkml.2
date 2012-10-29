Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2J2JGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:06:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:45866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2J2JF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:05:59 -0400
Message-ID: <1351501541.24721.1.camel@twins>
Subject: Re: [PATCH] hrtimer: Printing timer info when hitting BUG_ON()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        fei.li@intel.com, yanmin_zhang@linux.intel.com
Date: Mon, 29 Oct 2012 10:05:41 +0100
In-Reply-To: <1351508551.15558.1428.camel@cliu38-desktop-build>
References: <1351508551.15558.1428.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 19:02 +0800, Chuansheng Liu wrote:
> +/*
> + * dump_hrtimer_callinfo - print hrtimer information including:
> + * state, callback function, pid and start_site.
> +*/
> +static void dump_hrtimer_callinfo(struct hrtimer *timer)
> +{
> +
> +       char symname[KSYM_NAME_LEN];
> +
> +       if (lookup_symbol_name((unsigned long)(timer->function), symname) < 0) {
> +               pr_err("timer info: state/%lx, func/%pK\n",
> +                       timer->state, timer->function);
> +       } else {
> +               pr_err("timer info: state/%lx, func/%s",
> +                       timer->state, symname);
> +       }
> +
> +#ifdef CONFIG_TIMER_STATS
> +       if (lookup_symbol_name((unsigned long)(timer->start_site),
> +                                               symname) < 0) {
> +               pr_err("timer stats: pid/%d(%s), site/%pK\n",
> +                       timer->start_pid, timer->start_comm, timer->start_site);
> +       } else {
> +               pr_err("timer stats: pid/%d(%s), site/%s\n",
> +                       timer->start_pid, timer->start_comm, symname);
> +       }
> +#endif
> +} 

What's wrong with %pf ?
