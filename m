Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1LWQla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:41:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396Ab1LWQl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:41:28 -0500
Date: Fri, 23 Dec 2011 17:39:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111223163930.GA5983@elte.hu>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223161701.GF16765@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 23.12.11 15:40:40, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2011-12-23 at 14:53 +0100, Ingo Molnar wrote:
> > > > * Robert Richter <robert.richter@amd.com> wrote:
> > > > 
> > > > > > Also, could you quote example output of "perf script report 
> > > > > > ibs"?
> > > > > 
> > > > > IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x0000000000444780 IBS2:0x000000041af26780
> > > > > IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x00007f5efb44e3b2 IBS2:0x000000042fcff3b2
> > > > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065273 IBS2:0x0000000001065273
> > > > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff811a6320 IBS2:0x00000000011a6320
> > > > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065255 IBS2:0x0000000001065255
> > > > > IBS_FETCH sample on cpu7	IBS0: 0x00170004186a186a IBS1: 0x00007fbf0c687ca0 IBS2:0x000000041d345ca0
> > > > > IBS_FETCH sample on cpu7	IBS0: 0x00170003186a186a IBS1: 0x000000000043bb80 IBS2:0x000000041c351b80
> > > > > IBS_FETCH sample on cpu7	IBS0: 0x01370003186a186a IBS1: 0xffffffff813d5790 IBS2:0x00000000013d5790
> > > > > IBS_FETCH sample on cpu7	IBS0: 0x00030001186a186a IBS1: 0xffffffff8102bd00 IBS2:0x00000000013d5d00
> > > > 
> > > > That does not look very usable to users. So why should we merge 
> > > > this new ABI in its incomplete form with no complete usecase? 
> > > > Being usable is clearly not outside the scope of a new feature 
> > > > ...
> 
> So is it not useful to pull ibs data with native perf tools to 
> userspace? Is it not useful to have a dump of the raw data 
> too? Is it not useful to have perf script support that allows 
> user to easy implement their own script to parse the data they 
> are interested in? IBS is for experienced users, even I don't 
> know *everything* about what this data can be used for, but I 
> know people who know it. And they want to get this data out of 
> the kernel, using the perf_event syscall. Maybe they also 
> improve the perf tool with their knowledge.

No, i think you misunderstood me, i definitely think getting all 
the data out is perfectly fine and useful, if the hardware 
provides it. No need to make 'every' conceivable piece of IBS 
data useful straight away.

All i want is at least *one* common usecase to work fine. This 
allows us to see things in practice and it also provides the 
seed for further improvements.

Right now this does not seem to be the case: the 'report' 
portion only reports a raw hexa dump, not very useful to users.

Once something like 'perf report' works for some useful looking 
sub-case you can also tack on all the extra IBS goodies that 
specialized tools might need as well, i have no problem with 
providing that.

It's the same deal as with -rt or with LWP: niches are fine as 
long as they improve the common case as well.

Thanks,

	Ingo
