Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3ABPa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:30:27 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:7203 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab3ABPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:30:25 -0500
Date: Wed, 2 Jan 2013 15:30:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 07/27] nohz: Assign timekeeping duty to a non-full-nohz
 CPU
In-Reply-To: <1356799386-4212-8-git-send-email-fweisbec@gmail.com>
Message-ID: <0000013bfbe28263-98bca726-cf8f-4307-989d-472ea478e7f3-000000@email.amazonses.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com> <1356799386-4212-8-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2012, Frederic Weisbecker wrote:

> @@ -163,6 +164,8 @@ static int __init tick_nohz_full_setup(char *str)
>  	return 1;
>  }
>  __setup("full_nohz=", tick_nohz_full_setup);
> +#else
> +#define have_full_nohz_mask (0)
>  #endif
>
>  /*
> @@ -512,6 +515,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  		return false;
>  	}
>
> +	/* If there are full nohz CPUs around, we need to keep the timekeeping duty */
> +	if (have_full_nohz_mask && tick_do_timer_cpu == cpu)
> +		return false;
> +
>  	return true;
>  }
>
>

Ok so I guess this means that if I setup all cpus as nohz then a random
one will continue to do timekeeping?
