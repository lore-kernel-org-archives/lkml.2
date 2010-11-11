Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab0KKJRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:17:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab0KKJRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:17:32 -0500
Date: Thu, 11 Nov 2010 10:17:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
Message-ID: <20101111091704.GA31380@elte.hu>
References: <1289413460.2084.27.camel@laptop>
 <20101110184105.GH22410@elte.hu>
 <1289415645.12418.180.camel@gandalf.stny.rr.com>
 <20101110191127.GA6190@nowhere>
 <20101110202316.GA32396@Krystal>
 <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>
 <20101110225115.GB9299@Krystal>
 <alpine.LFD.2.00.1011110004520.2900@localhost6.localdomain6>
 <20101110232829.GC9299@Krystal>
 <alpine.LFD.2.00.1011110046370.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011110046370.2900@localhost6.localdomain6>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:

> > I'd like to start with an implementation that skips some of these requirements 
> > initially, but what I really think we need to figure out is how we organize our 
> > ABIs to finally support these requirements.

Note, there is an existing ABI in place, please use that. (It's highly extensible so 
it can support just about any ABI experiment that can even be turned into a smooth 
ABI replacement.)

I think Frederic just started iterating it - but if Mathieu and Steve helps out it 
will all happen faster.

> I did not say, that you should not think about this, but the progress so far in 
> more than TWO YEARS is exaclty ZERO. And that's what I'm concerned about.

Yes, indeed that is the main problem i see as well.

Most of the problems listed in the various documents can be solved iteratively in 
the existing facilities. There is not a single requirement where Peter or me said 
'No, this cannot be done, go away!'. Each and every item was answered with: 'sure, 
we can do that' - or at worst with a 'do we really need it?'. Each and every item 
fits naturally into existing goals as well - so it's not like some different world 
view is being forced on anyone.

We only have one basic condition: please introduce these thing step by step in the 
existing ABI.

This is a must-have for tools, and there is another very important factor as well: a 
couple of items can have disadvantages beyond the claimed advantages, so we want to 
be able to evaluate the effects in isolation, test them and if needed, undo them. It 
will settle the 'do we really need this?' kind of sub-arguments for sub-features.

So being intelligent about it, being iterative is my only requirement to you guys: 
you are free to change anything, go wild, but please make it iterative and dont try 
to fork the tooling and developer community.

The time has come to not grow the list of requirements but to shrink it.

Thanks,

	Ingo
