Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0KKOfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:35:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59729 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab0KKOfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:35:04 -0500
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
 kthreads
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333876.8661.147.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333876.8661.147.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 15:34:56 +0100
Message-ID: <1289486096.2084.123.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:31 +0200, Raistlin wrote:
> @@ -6071,7 +6104,7 @@ void sched_idle_next(void)
>          */
>         raw_spin_lock_irqsave(&rq->lock, flags);
>  
> -       __setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
> +       __setscheduler_dl_special(rq, p);
>  
>         activate_task(rq, p, 0);
>   

Ingo, happen to know if this is really needed these days? hotplug should
have migrated all other tasks away, leaving only the idle task to run.
