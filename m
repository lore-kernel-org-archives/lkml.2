Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab2EPSag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:30:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39170 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab2EPSaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:30:35 -0400
Message-ID: <1337193010.27694.146.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Wed, 16 May 2012 20:30:10 +0200
In-Reply-To: <1337096141.27694.82.camel@twins>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 17:35 +0200, Peter Zijlstra wrote:
> But really short, look at kernel/sched/core.c:default_topology[]

The reason I want to push this into the arch is that the current one
size fits all topology really doesn't fit.

On x86 there's stuff like the Intel Core2 Quad which is two dual-core
dies glued together resulting in a socket with 2 cache domains. And the
current topology simply cannot represent this.

There's the s390 'book' domain, which is now littering generic code.

And AMD Magny-Cours which has two nodes on a socket.


But I want to very much limit the arch interface so that we don't get
the current mess of arch maintainers having to guess at things like
SD_INIT_BOOK and what all these various random numbers in there mean.
