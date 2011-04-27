Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1D0GoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:44:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50529 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1D0GoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:44:10 -0400
Date: Wed, 27 Apr 2011 08:43:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110427064342.GE17079@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <1303809958.20212.219.camel@twins>
 <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu>
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


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Tue, 26 Apr 2011, Peter Zijlstra wrote:
> 
> > > That's why people use libpfm4.  or PAPI.  And they do.
> > 
> > And how is typing in hex numbers different from typing in model specific
> > event names? 
> 
> Reall... quick, tell me what event 0x53cf28 corresponds to on a core2.
> 
> Now if I said L2_IFETCH:BOTH_CORES you know several things about what it is.

Erm, that assumes you already know that magic incantation. Most of the users 
who want to do measurements and profiling do not know that. So there's little 
difference between:

 - someone shows them the 0x53cf28 magic code
 - someone shows them the L2_IFETCH:BOTH_CORES magic symbol

So you while hexa values have like 10% utility, the stupid, vendor-specific 
event names you are pushing here have like 15% utility.

In perf we are aiming for 100% utility, where if someone knows something about 
CPUs and can type 'cycles', 'instructions' or 'branches', will get the obvious 
result.

This is not a difficult usability concept really.

Thanks,

	Ingo
