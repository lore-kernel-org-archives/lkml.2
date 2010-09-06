Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0IFM7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:59:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0IFM7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:59:39 -0400
Date: Mon, 6 Sep 2010 14:59:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100906125905.GA25414@elte.hu>
References: <4C84B088.5050003@redhat.com>
 <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C84E265.1020402@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0280]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>  On 09/06/2010 03:43 PM, Ingo Molnar wrote:
> >
> > Yes. The filter engine is a safe, in-kernel interpreted language in 
> > the making. The C syntax was chosen because it's close to the heart 
> > of every kernel developer.
> >
> > It might make sense to bring this concept a few steps further. Looks 
> > rather complex but also rather cool ...
> 
> Is this a roundabout way of saying "jit"?

Partly. I'm not sure we want to actually upload programs in bytecode 
form. ASCII is just fine - just like a .gz Javascript is fine for web 
apps. (and in most cases compresses down better than the bytecode 
equivalent)

So a clear language (the simpler initially the better) plus an in-kernel 
compiler.

This could be used for far more than just instrumentation: IMO security 
policies could be expressed in such a way. (Simplified, they are quite 
similar to filters installed on syscall entry/exit, with the ability of 
the filter to influence whether the syscall is performed.)

> If so, I'm all for it.  I could use one myself.

Good ;-)

Thanks,

	Ingo
