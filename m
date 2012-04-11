Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711Ab2DKQAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:00:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab2DKQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:00:29 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=vU621Mr7Yx6zvSfQ7mEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334160026.23924.255.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, Dario Faggioli <raistlin@linux.it>,
        Insop Song <insop.song@ericsson.com>, liming.wang@windriver.com
Date: Wed, 11 Apr 2012 12:00:26 -0400
In-Reply-To: <4F81F2F1.8010105@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	 <4F7F285A.1010703@gmail.com>
	 <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
	 <4F81F2F1.8010105@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 22:20 +0200, Juri Lelli wrote:
> >
> >>>> +#ifdef CONFIG_SMP
> >>>> +       /*
> >>>> +        * In the unlikely case current and p have the same deadline
> >>>> +        * let us try to decide what's the best thing to do...
> >>>> +        */
> >>>> +       if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0&&
> >>>> +           !need_resched())
> >>>
> >>> please recheck !need_resched(), say rq->curr need reschedule?
> >>
> >> Sorry, I don't get this..
> >>
> > Perhaps smp_processor_id() != rq->cpu
> >
> 
> need_resched is actually checked...
> 

I guess what Hillf is trying to say is,

s/!need_resched()/!test_tsk_need_resched(rq->curr)/

-- Steve


