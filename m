Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0KJUVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:21:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60725 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0KJUVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:21:32 -0500
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
In-Reply-To: <1288333814.8661.146.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 21:21:18 +0100
Message-ID: <1289420478.2084.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> +static void update_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +       struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +       struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +       /*
> +        * The arrival of a new instance needs special treatment, i.e.,
> +        * the actual scheduling parameters have to be "renewed".
> +        */
> +       if (dl_se->dl_new) {
> +               setup_new_dl_entity(dl_se);
> +               return;
> +       }
> +
> +       if (dl_time_before(dl_se->deadline, rq->clock) ||
> +           dl_entity_overflow(dl_se, rq->clock)) {
> +               dl_se->deadline = rq->clock + dl_se->dl_deadline;
> +               dl_se->runtime = dl_se->dl_runtime;
> +       }
> +} 

Can't we loose runtime deficit this way?
