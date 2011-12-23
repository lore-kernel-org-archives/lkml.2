Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1LWQRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:17:13 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:7146
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184Ab1LWQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:17:11 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz936eK1432N98dK4015Lzz1202hzz8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWNZWI-02-6Y0-02
X-M-MSG: 
Date: Fri, 23 Dec 2011 17:17:01 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111223161701.GF16765@erda.amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111223144040.GB2297@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.11 15:40:40, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2011-12-23 at 14:53 +0100, Ingo Molnar wrote:
> > > * Robert Richter <robert.richter@amd.com> wrote:
> > > 
> > > > > Also, could you quote example output of "perf script report 
> > > > > ibs"?
> > > > 
> > > > IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x0000000000444780 IBS2:0x000000041af26780
> > > > IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x00007f5efb44e3b2 IBS2:0x000000042fcff3b2
> > > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065273 IBS2:0x0000000001065273
> > > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff811a6320 IBS2:0x00000000011a6320
> > > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065255 IBS2:0x0000000001065255
> > > > IBS_FETCH sample on cpu7	IBS0: 0x00170004186a186a IBS1: 0x00007fbf0c687ca0 IBS2:0x000000041d345ca0
> > > > IBS_FETCH sample on cpu7	IBS0: 0x00170003186a186a IBS1: 0x000000000043bb80 IBS2:0x000000041c351b80
> > > > IBS_FETCH sample on cpu7	IBS0: 0x01370003186a186a IBS1: 0xffffffff813d5790 IBS2:0x00000000013d5790
> > > > IBS_FETCH sample on cpu7	IBS0: 0x00030001186a186a IBS1: 0xffffffff8102bd00 IBS2:0x00000000013d5d00
> > > 
> > > That does not look very usable to users. So why should we merge 
> > > this new ABI in its incomplete form with no complete usecase? 
> > > Being usable is clearly not outside the scope of a new feature 
> > > ...

So is it not useful to pull ibs data with native perf tools to
userspace? Is it not useful to have a dump of the raw data too? Is it
not useful to have perf script support that allows user to easy
implement their own script to parse the data they are interested in?
IBS is for experienced users, even I don't know *everything* about
what this data can be used for, but I know people who know it. And
they want to get this data out of the kernel, using the perf_event
syscall. Maybe they also improve the perf tool with their knowledge.

Oprofile also has support for IBS in a very raw way, and there are
users for it. Remember, there are also plans to rewrite the oprofile
daemon to use perf_event. If there isn't any confidence that
perf_event will get the same features so it can be used for this,
people might better stick with that what they have.

> > > Integrating it into perf report should not be *that* hard, 
> > > you've done most of the hard work already. But without that 
> > > step we just don't know how complete and usable the whole 
> > > thing is.

We don't need a feature complete (which features?) implementation to
see use cases for this. AFAIK there is no doubt anymore about the
user/kernel interface implementation. So your argument is
questionable. If you look at other kernel features (also other perf
features) and how they got in, most of them are not perfect in the
beginning.

We also should give others the opportunity to actually use IBS, to
give feedback, to improve the tools, to work with it. Most of the
current patches wont change anymore, the code is ready. As long as the
code is not in the repostitory it is much harder for people to work
with it. They usually don't deal with some patches flying around.

We waste our time with reposting, reviewing (people seem to no longer
do this, because they are tiered), rebasing it, testing it. Do you
fear we stop working to improve the code as soon as you applied the
patches?  Have you ever had this feeling in the past? We invest a high
amount of time in all this, please let us know if this is not worth
the effort. Almost 2 years ago I posted my first IBS patches for
perf...

And, is the kernel ever ready? There is no completion at all. There is
an onging development in small steps. I don't see why you demand this
100%-fits-for-all-usecases solution, that you also don't know much
about. There isn't one, and there wont be any. Relax your position
that everything must be there in the beginning.

To me these are reasons enough to merge it.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

