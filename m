Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2GQBH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:07:58 -0400
Received: from ozlabs.org ([203.10.76.45]:50918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab2GQBH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:07:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 7/7] infiniband: ehca: Use hotplug thread infrastructure
In-Reply-To: <20120716103948.775527032@linutronix.de>
References: <20120716103749.122800930@linutronix.de> <20120716103948.775527032@linutronix.de>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 17 Jul 2012 09:57:30 +0930
Message-ID: <87y5mjw7t9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012 10:42:39 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> +	while (1) {
> +		cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
> +		if (cpu >= nr_cpu_ids)
> +			cpu = cpumask_first(cpu_online_mask);
> +		pool->last_cpu = cpu;
> +		/* Might be on the way out */
> +		if (per_cpu_ptr(pool->cpu_comp_tasks, cpu)->active)
> +			break;
> +	}

I always look twice at while(1) loops; I'm sure there's a do-while
hiding in there.

Overall, the patch series looks like a very nice cleanup.

Thanks!
Rusty.
