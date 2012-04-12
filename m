Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2DLM21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 08:28:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56202 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab2DLM20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 08:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <1334153450.23924.243.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	<1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	<CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	<1334153450.23924.243.camel@gandalf.stny.rr.com>
Date: Thu, 12 Apr 2012 20:28:24 +0800
Message-ID: <CAJd=RBDqsr8aBNxokrb5Rc90RNu41ZRLEJJDdXibf238k2c6oQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fcheccon@jasper.es
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:10 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-04-06 at 21:39 +0800, Hillf Danton wrote:
>
>> > +static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
>> > +{
>> > +       dl_rq = &rq_of_dl_rq(dl_rq)->dl;
>> > +
>> > +       dl_rq->dl_nr_total++;
>> > +       if (dl_se->nr_cpus_allowed > 1)
>> > +               dl_rq->dl_nr_migratory++;
>> > +
>> > +       update_dl_migration(dl_rq);
>>
>>       if (dl_se->nr_cpus_allowed > 1) {
>>               dl_rq->dl_nr_migratory++;
>>               /* No change in migratory, no update of migration */
>
> This is not true. As dl_nr_total changed. If there was only one dl task
> queued that can migrate, and then another dl task is queued but this
> task can not migrate, the update_dl_migration still needs to be called.
> As dl_nr_migratory would be 1, but now dl_nr_total > 1. This means we
> are now overloaded.
>
	if (2 == dl_nr_migratory + dl_nr_total)
		rq was not overloaded;

	after enqueuing a deadline task that is not migratory,

	if (current task is not preempted)
		rq remains not overloaded;

	else if (current task is not pushed out) {
		if (rq is not overloaded)
			maintenance of overloaded is __corrupted__;
	}

btw, same behavior in RTS?
