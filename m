Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab2ESXN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 19:13:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:46997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2ESXN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 19:13:26 -0400
Message-ID: <1337469181.573.151.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, paulmck@linux.vnet.ibm.com,
        smuckle@quicinc.com, khilman@ti.com, Robin.Randhawa@arm.com,
        suresh.b.siddha@intel.com, thebigcorporation@gmail.com,
        venki@google.com, panto@antoniou-consulting.com, mingo@elte.hu,
        paul.brett@intel.com, pdeschrijver@nvidia.com, pjt@google.com,
        efault@gmx.de, fweisbec@gmail.com, geoff@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Sun, 20 May 2012 01:13:01 +0200
In-Reply-To: <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-19 at 10:08 -0700, Linus Torvalds wrote:
> Don't try to build up some perfect NUMA topology and then
> try to see how insanely well you can match a particular machine. Make
> some generic "roughly like this" topology with (say) four three of
> NUMAness, and then have architectures say "this is roughly what my
> machine looks like".

> In particular, don't even try to give random "weights" to how close
> things are to each other. Sure, you can parse (and generate) those
> complex NUMA tables, but nobody is *ever* smart enough to really use
> them. Once you move data between boards/nodes, screw the number of
> hops. You are NOT going to get some scheduling decision right that
> says "node X is closer to node Y than to node Z". Especially since the
> load is invariably going to access non-node memory too *anyway*. 

I suspect this is related to the patch I recently did that creates numa
levels from the node_distance() table.

The fact is, that patch removed arch specific code. And yes initially I
tried to use the weights for more than simply creating the balance
levels but I've already realized that was a mistake and removed that
part.

So currently all it does is create load-balance levels based on how far
apart nodes are said to be and decrease the balance rate roughly
proportional to how many cpus are in each level.

The node_distance() table is mostly already a fabrication of the
arch/firmware; some people do exactly what you suggested, expose simple
groups of board vs rest and not bother with fine details.

I used the node_distance() table simply because this was an existing
arch interface that provides exactly what was needed and is used for
exactly this purpose in the mm/ part of the kernel as well.


