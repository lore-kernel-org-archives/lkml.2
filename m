Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0DMSWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:22:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:52379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0DMSWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:22:31 -0400
Subject: Re: [RFC][PATCH 02/11] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267384639.13676.87.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
	 <1267384639.13676.87.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 20:22:16 +0200
Message-ID: <1271182936.4807.1877.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:17 +0100, Raistlin wrote:
> +       /*
> +        * Arm the timer to fire at wakeup, tying to compensate for
> +        * the fact that wakeup is actually coming from rq->clock and
> +        * not from hrtimer's time base reading.
> +        */
> +       act = ns_to_ktime(wakeup);
> +       now = hrtimer_cb_get_time(&dl_se->dl_timer);
> +       delta = ktime_to_ns(now) - rq->clock;
> +       act = ktime_add_ns(act, delta); 

This is sad, but I'm afraid a reality we have to live with..
