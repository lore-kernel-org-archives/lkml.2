Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0DSTBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:01:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:54842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0DSTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:01:46 -0400
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Peter Zijlstra <peterz@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
       arjan@infradead.org, csadler@google.com, ranjitm@google.com,
       kenchen@google.com, dawnchen@google.com
In-Reply-To: <h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <1271317886.32749.69.camel@laptop>
	 <h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 21:01:41 +0200
Message-ID: <1271703701.1676.235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 10:20 -0700, Salman Qazi wrote:
> On Thu, Apr 15, 2010 at 12:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
> >> As we discussed earlier this year, Google has an implementation that it
> >> would like to share.  I have finally gotten around to porting it to
> >> v2.6.33 and cleaning up the interfaces.  It is provided in the following
> >> messages for your review.  I realize that when we first discussed this
> >> idea, a lot of ideas were presented for enhancing it.  Thanks alot for
> >> your suggestions.  I haven't gotten around to implementing any of them.
> >
> > .33 is way too old to submit patches against.
> 
> Will bump up the version when I refresh the change.
> 
> >
> > That said, I really really dislike this approach, I would much rather
> > see it tie in with power aware scheduling.
> 
> I think I can see your point:  there is potentially better information
> about the power consumption of the CPU beyond the time it was busy.
> But please clarify: is your complaint the lack of use of this
> information or are you arguing for a deeper integration into the
> scheduler (I.e. implementing it as part of the scheduler rather than
> an independent thread) or both?

Right, so the IBM folks who were looking at power aware scheduling were
working on an interface to quantify the amount of power to save.

But their approach, was an extension of the regular power aware
load-balancer, which basically groups tasks onto sockets so that whole
sockets can go idle.

However Arjan explained to me that your approach, which idles the whole
machine, has the advantage that also memory banks can go into idle mode
and save power.

Still in the interest to cut back on power-saving interfaces it would be
nice to see if there is anything we can do to merge these things, but I
really haven't thought much about that yet.

