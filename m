Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1LEOTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:19:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab1LEOTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:19:38 -0500
Date: Mon, 5 Dec 2011 15:17:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111205141749.GC28866@elte.hu>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201231751.GA4961@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Fri, Dec 02, 2011 at 12:07:10AM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-12-01 at 14:14 -0800, Greg KH wrote:
> > > greg k-h
> > 
> > Greg, why are you merging this crap anyway? Aren't there enough tracer
> > thingies around already?
> 
> I don't know, is there?
> 
> There's some reason the distros, and users, still use lttng, 
> so I'm guessing that it fits the needs of quite a few people.

Same goes for a whole lot of other crap that distros are 
carrying. Would we want to merge a different CPU scheduler or 
the 4g:4g patch or a completely new networking stack into 
drivers/staging/? I don't think so.

I.e. putting LTTNG into drivers/staging/ will not really solve 
anything - and in may in fact delay any sane technical 
resolution:

There's a difference between a driver that has to go into 
drivers/staging/ because nobody cares enough [and the driver 
isnt high quality enough yet], and a core kernel feature that we 
DO care about and which HAS BEEN REJECTED IN ITS FORM.

> That's why I'm merging it, if that the in-kernel stuff 
> obsoletes lttng, great, let me, and the distros know.

I'm NAK-ing the LTTNG driver really, as it's a workaround for a 
core kernel NAK.

Mathieu, please work with the tracing folks who DO care about 
this stuff. It's not like there's a lack of interest in this 
area, nor is there a lack of willingness to take patches. What 
there is a lack of is your willingness to actually work on 
getting something unified, integrated to users...

LTTNG has been going on for how many years? I havent seen many 
steps towards actually *merging* its functionality - you insist 
on doing your own random thing, which is different in random 
ways. Yes, some of those random ways may in fact be better than 
what we have upstream - would you be interested in filtering 
those out and pushing them upstream? I certainly would like to 
see that happen.

We want to pick the best features, and throw away current 
upstream code in favor of superior out of tree code - this 
concept of letting crap sit alongside each other when people do 
care i cannot agree with.

Thanks,

	Ingo
