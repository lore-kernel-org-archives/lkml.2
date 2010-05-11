Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0EKU14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:27:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0EKU1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:27:54 -0400
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled / 
 running values are incorrect
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: eranian@gmail.com, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <AANLkTilVGy3nLymHUj-blglsL3y5ApyhUWrunxJYeQPb@mail.gmail.com>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
	 <1273588935.1810.6.camel@laptop>
	 <h2i7c86c4471005111255ke689a7acz3a9bbb80480235b0@mail.gmail.com>
	 <1273608676.1810.61.camel@laptop>
	 <AANLkTilVGy3nLymHUj-blglsL3y5ApyhUWrunxJYeQPb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 22:27:51 +0200
Message-ID: <1273609671.1810.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 22:23 +0200, Stephane Eranian wrote:
> On Tue, May 11, 2010 at 10:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-05-11 at 21:55 +0200, stephane eranian wrote:
> >> Events are also grouped in this example. Both this same issue exists
> >> also when only
> >> one event is used. I suspect an update_event_times() or
> >> update_group_times() is also
> >> missing on the sampling path in perf_overflow_handler().
> >
> > Hrmm, you're right, except fixing that is non-trivial.
> > update_event_times() wants to be called with ctx->lock held and we can't
> > do that from NMI context.
> >
> Why do you need the lock when the event is running on a CPU in NMI context?
> What action issued remotely could modify the data used by this function without
> the need for IPI?

Not sure, would at the very least have to verify that. I'll try and have
a look.

