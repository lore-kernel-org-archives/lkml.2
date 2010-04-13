Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0DMSWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:22:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:52380 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab0DMSWb convert rfc822-to-8bit (ORCPT
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
Date: Tue, 13 Apr 2010 20:22:15 +0200
Message-ID: <1271182935.4807.1876.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:17 +0100, Raistlin wrote:
> +/*
> + * Pure Earliest Deadline First (EDF) scheduling does not deal with the
> + * possibility of a task lasting more than what it declared, and thus
> + * exhausting its runtime.
> + *
> + * Here we are interested in making runtime overrun possible, but we do
> + * not want a task which is misbehaving to affect the scheduling of all
> + * other tasks.
> + * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
> + * is used, in order to confine each task within its own bandwidth.
> + *
> + * This function deals exactly with that, and ensures that when the runtime
> + * of a task is replenished, its deadline is also postponed. That results
> + * in "priority unboosting" for the overrunning task, and makes it impossible
> + * for it to cause unexpected interfere to other tasks in the system.
> + */ 

This is not about lock/inheritance related overrun, right? But simply a
task that got its WCET wrong.


