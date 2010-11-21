Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0KURpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:45:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47790 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab0KURpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:45:18 -0500
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
References: <1290340907.2245.125.camel@localhost>
	 <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
	 <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 21 Nov 2010 18:45:29 +0100
Message-ID: <1290361529.2153.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 13:22 +0100, Stephane Eranian wrote:
> On Sun, Nov 21, 2010 at 1:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> >>
> >>              samples  pcnt function               DSO
> >>              _______ _____ ______________________
> >> ____________________________________
> >>
> >>                 8.00 18.6% kallsyms_expand_symbol [kernel.kallsyms]
> >
> > Reporting a symbol for an uncore event seems highly misleading.
> > After all the uncore counter has no idea for which core the event was,
> > so there isn't really any instruction pointer to report.
> > The event could be event caused by a PCI device or similar.
> >
> > For per function monitoring of uncore events one has to use
> > OFFCORE_RESPONSE, like I implemented recently.
> >
> > I would suggest to not report any symbol names for uncore events.
> > Doing so just will confuse users.
> >
> > In fact I suspect uncore events are only really useful
> > with "stat", but not with "top", or if they are used in top
> > then the symbol reporting should be disabled.
> >
> I agree, uncore should only be used for counting on a
> per-cpu basis. You can leave the perf tool as is, but
> that opens up the risk of misinterpretation by many users,
> or you restrict this in the tool directly which is the better
> solution in my mind.

I would argue against restricting the tool, print a warning perhaps. I
mean, give the user all the rope he needs and tell him how to tie the
knot is the unix way, right? :-)
