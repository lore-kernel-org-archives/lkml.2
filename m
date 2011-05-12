Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab1ELWA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:00:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968Ab1ELWA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:00:26 -0400
Date: Fri, 13 May 2011 00:00:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512220021.GA21732@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
 <BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
 <20110512213542.GB17596@elte.hu>
 <BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
 <20110512215023.GA20939@elte.hu>
 <BANLkTimO-8QNumkjzYia5P-V3pm_4JMLxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimO-8QNumkjzYia5P-V3pm_4JMLxg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Thu, May 12, 2011 at 11:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> On Thu, May 12, 2011 at 11:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * Stephane Eranian <eranian@google.com> wrote:
> >> >
> >> >> The other contradiction, I see, is that you have perf_event paranoia level
> >> >> and this new kptr masquerading feature which conflict with each
> >> >> other.
> >> >>
> >> >> You can be allowed to monitor at the kernel level (paranoid=1, default)
> >> >> but you cannot correlate symbols:
> >> >>
> >> >> $ perf record -e cycles:k foo
> >> >>
> >> >> I suspect if you have this kptr thing turned on, then you need to disallow
> >> >> monitoring at the kernel level too.
> >> >
> >> > The better (and consistent) solution would be to turn the kptr_restrict thing
> >> > off - see the patch i sent.
> >>
> >> I saw that. But I think that when someone turns it back on, then you need to
> >> increase the perf_events paranoia level to disallow kernel monitoring to
> >> regular users such that you maintain consistency across the board.
> >
> > Dunno, i would not couple them necessarily - certain users might still have
> > access to kernel symbols via some other channel - for example the System.map.
>
> Ok, that's true, but then you'd need to have perf print a message or refuse to
> use /proc/kallsyms and suggest that the user provides a System.map.

Correct - the right approach would be to just use what we had in earlier 
versions, an 'unknown symbol' kind of catch-all entry that shows how much
stuff we did not recognize.

Thanks,

	Ingo
