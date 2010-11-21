Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0KUOT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:19:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:11957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab0KUOT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:19:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="351430321"
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
References: <1290340907.2245.125.camel@localhost>
	 <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
	 <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 22:19:26 +0800
Message-Id: <1290349166.2245.181.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 20:22 +0800, Stephane Eranian wrote:
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

I agree restricting the tool is a better idea.
How about below?

#one cpu stat is allowed
perf stat -e ruNNNN -C <cpu>
perf stat -e ruNNNN -C <cpu> -p <pid>
perf stat -e ruNNNN -C <cpu> -- <command>

#per thread is NOT allowed
perf stat -e ruNNNN -p <pid>
perf stat -e ruNNNN -- <command>

#all cpus stat is NOT allowed, because it will mess the results
perf stat -e ruNNNN -a






