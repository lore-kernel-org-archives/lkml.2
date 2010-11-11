Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0KKNNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:13:46 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52523 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab0KKNNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:13:45 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
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
In-Reply-To: <1289438335.13577.462.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289420478.2084.54.camel@laptop>
	 <1289438335.13577.462.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 14:13:38 +0100
Message-ID: <1289481218.2084.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 02:18 +0100, Raistlin wrote:
> On Wed, 2010-11-10 at 21:21 +0100, Peter Zijlstra wrote:
> > > +       if (dl_time_before(dl_se->deadline, rq->clock) ||
> > > +           dl_entity_overflow(dl_se, rq->clock)) {
> > > +               dl_se->deadline = rq->clock + dl_se->dl_deadline;
> > > +               dl_se->runtime = dl_se->dl_runtime;
> > > +       }
> > > +} 
> > 
> > Can't we loose runtime deficit this way?

>  - if unblocking happens _before_ it becomes eligible again, the 
>    enqueue will be later handled by the dl_timer itself, when it'll
>    fire, and the task will be given a replenishment starting from its
>    negative runtime;
>  - if unblocking happens _later_ than the firing of dl_timer, resetting
>    the scheduling parameters should be just fine, from the bandwidth
>    point of view.
> 
> Does it make sense?

Yes, I think so. Thanks!
