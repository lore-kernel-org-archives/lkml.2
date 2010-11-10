Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0KJSuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:50:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0KJSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:50:08 -0500
Date: Wed, 10 Nov 2010 19:49:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110184931.GI22410@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
 <20101110101450.GA18481@elte.hu>
 <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <20101110174852.GB4001@elte.hu>
 <1289412329.12418.177.camel@gandalf.stny.rr.com>
 <987664A83D2D224EAE907B061CE93D5301649A6F7B@orsmsx505.amr.corp.intel.com>
 <1289413916.2084.30.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289413916.2084.30.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2010-11-10 at 10:23 -0800, Luck, Tony wrote:
> > > A few of things that pop up quickly are:
> > >
> > > 1) lockless
> > 
> > This is a clear requirement for use in h/w error
> > reporting too.  Taking locks in NMI or machine
> > check handler isn't an option.
> 
> Don't worry, lots of PMIs are NMIs, perf needs to be fully NMI safe
> otherwise things simply don't work.

Yep, in fact perf was fully NMI safe earlier than the ftrace ring-buffer.

When perf code is NMI unsafe we notice it very quickly. I regularly record millions 
of events per second.

Thanks,

	Ingo
