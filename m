Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1LWOmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:42:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1LWOmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:42:38 -0500
Date: Fri, 23 Dec 2011 15:40:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111223144040.GB2297@elte.hu>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324649698.24803.55.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2011-12-23 at 14:53 +0100, Ingo Molnar wrote:
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > > Also, could you quote example output of "perf script report 
> > > > ibs"?
> > > 
> > > IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x0000000000444780 IBS2:0x000000041af26780
> > > IBS_FETCH sample on cpu6	IBS0: 0x00170003186a186a IBS1: 0x00007f5efb44e3b2 IBS2:0x000000042fcff3b2
> > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065273 IBS2:0x0000000001065273
> > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff811a6320 IBS2:0x00000000011a6320
> > > IBS_FETCH sample on cpu6	IBS0: 0x01370003186a186a IBS1: 0xffffffff81065255 IBS2:0x0000000001065255
> > > IBS_FETCH sample on cpu7	IBS0: 0x00170004186a186a IBS1: 0x00007fbf0c687ca0 IBS2:0x000000041d345ca0
> > > IBS_FETCH sample on cpu7	IBS0: 0x00170003186a186a IBS1: 0x000000000043bb80 IBS2:0x000000041c351b80
> > > IBS_FETCH sample on cpu7	IBS0: 0x01370003186a186a IBS1: 0xffffffff813d5790 IBS2:0x00000000013d5790
> > > IBS_FETCH sample on cpu7	IBS0: 0x00030001186a186a IBS1: 0xffffffff8102bd00 IBS2:0x00000000013d5d00
> > 
> > That does not look very usable to users. So why should we merge 
> > this new ABI in its incomplete form with no complete usecase? 
> > Being usable is clearly not outside the scope of a new feature 
> > ...
> > 
> > Integrating it into perf report should not be *that* hard, 
> > you've done most of the hard work already. But without that 
> > step we just don't know how complete and usable the whole 
> > thing is.
> 
> perf annotate like output might make more sense for IBS, maybe 
> not decode all the information that's in there, but at least a 
> number of the most useful measurements for each type and 
> present multiple columns in front of the instructions.
> 
> Ingo, the trouble with IBS is that it doesn't measure 
> something, its a measure everything together like thing, so 
> what particular part of this massive bulk data do you use to 
> create your histograms?

My point is that a useful angle to it has to be presented for it 
to be useful for upstream.

The bit that looks useful about IBS is skid-free sampling. So as 
long as the 'bulk data' contains enough information to do a 
'perf record -e instructions:p' work-alike thing it would be 
useful, right?

Sadly precise cycles sampling is not possible via IBS, right?

Thanks,

	Ingo

[*] Sidenote: i suspect the RIP+1 sampling artifact cannot be
    gotten rid of on AMD CPUs, right?

