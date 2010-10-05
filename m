Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0JETFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:05:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab0JETFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:05:31 -0400
Date: Tue, 5 Oct 2010 21:05:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Richter, Robert" <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC 0/3] Basic support for LWP
Message-ID: <20101005190501.GA21916@elte.hu>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
 <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
 <20101005145155.GD173@escobedo.osrc.amd.com>
 <alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
 <20101005182739.GE173@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005182739.GE173@escobedo.osrc.amd.com>
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


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> But thats not required to use LWP instructions. Maybe Robert will add 
> it to perf some day, or maybe not. It is completely optional, and how 
> it is implemented at some point in the future is completely irrelevant 
> to the basic support of LWP.

It isnt irrelevant. If the concept is implemented in a crappy way, if 
there are random user-space libraries that do not properly expose these 
capabilities and do not allow them to extend existing perf functionality 
in a natural way then we might be better off not adding overhead to the 
scheduler and not enabling it at all.

So thoughts need to be made what the point of it all is and how it 
integrates into perf. If it doesnt integrate, if the whole plan is to 
just get it to user-space where it can be messed up freely in some CPU 
specific way then color me thoroughly uninterested. We have a generic 
instrumentation framework for a reason.

We very much want to know the structure of that area and want to make 
use of it not just on a per task basis. We also want to expose it all in 
a more generalized form.

I cannot believe something like this was committed into silicon without 
at minimum talking to people who have a clue about where it will (and 
should) all go ...

	Ingo
