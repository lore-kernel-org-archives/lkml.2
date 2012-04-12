Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272Ab2DLNfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:35:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248Ab2DLNfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:35:40 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=uom53cjYOqZcOOW5bbsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334237738.23924.334.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fcheccon@jasper.es
Date: Thu, 12 Apr 2012 09:35:38 -0400
In-Reply-To: <CAJd=RBB1_USDhxgHojaQ27xVREz_jV8u-sCzwgmv8W-khtNZNQ@mail.gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	 <1334153450.23924.243.camel@gandalf.stny.rr.com>
	 <CAJd=RBDqsr8aBNxokrb5Rc90RNu41ZRLEJJDdXibf238k2c6oQ@mail.gmail.com>
	 <1334235109.23924.332.camel@gandalf.stny.rr.com>
	 <CAJd=RBB1_USDhxgHojaQ27xVREz_jV8u-sCzwgmv8W-khtNZNQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 20:56 +0800, Hillf Danton wrote:

> >>       if (2 == dl_nr_migratory + dl_nr_total)
> >>               rq was not overloaded;
> >>
> >>       after enqueuing a deadline task that is not migratory,
> >
> > Now rq would be overloaded because:
> >
> >        dl_nr_migratory + dl_nr_total == 3
> >
> 
> Which is the current task, and where?

More riddles?

The current task is the one executing on the CPU.

-- Steve

> 
> >
> >>
> >>       if (current task is not preempted)
> >>               rq remains not overloaded;
> >
> > s/not//
> >
> >>
> >>       else if (current task is not pushed out) {
> >>               if (rq is not overloaded)
> >>                       maintenance of overloaded is __corrupted__;
> >>       }
> >>
> >> btw, same behavior in RTS?
> >
> > I still don't understand what you are saying.
> >
> > I can see your scenario happening with the change you are suggesting
> > though.
> >
> > -- Steve
> >
> >


