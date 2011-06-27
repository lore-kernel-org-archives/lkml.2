Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab1F0Py0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:54:26 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27549
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752468Ab1F0PyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:54:20 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz936eK4015L1432N98dKzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNGHD8-01-2QN-02
X-M-MSG: 
Date: Mon, 27 Jun 2011 17:51:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vince Weaver <vweaver1@eecs.utk.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        "Przywara, Andre" <Andre.Przywara@amd.com>
Subject: Re: [patch] perf_events: even more wrong events for AMD fam10h
Message-ID: <20110627155106.GG4590@erda.amd.com>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
 <alpine.DEB.2.00.1106071701560.21714@cl320.eecs.utk.edu>
 <1309173741.6701.104.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309173741.6701.104.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.06.11 07:22:21, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 17:07 -0400, Vince Weaver wrote:
> > Here are two more problems I found with the superlative "generalized" 
> > events on AMD fam10h.
> > 
> > The "l1-dcache-loads" event measures loads *and* stores.
> >     This might be as close as you can get on AMD, but it's still wrong
> >       as it's not what Intel measures.  
> >     My patch removes it.  Better might be to add a proper
> >     "l1-dcache-access" event.
> 
> The question to ask is, does it still have a strong correlation?

Vince,

do you think it is worth to introduce l1-dcache-access?

> 
> > The "l1-dcache-load-miss" event is an invalid event. (0x141).
> >     From what I can tell that event (DATA_CACHE_MISSES) does not
> >     take a mask.  It should be 0x41.  And it's actually measuring
> >     all misses, not just load misses, see above.
> 
> See commit 83112e688f5f05dea1e63787db9a6c16b2887a1d. Also same as above.

It is still event 0x41, but bit 0 of the unit mask is set now for
family 15h.

> 
> > The "l1-dcache-stores" event does not work.  See the
> >      ./validation/l1-dcache-stores test found in 
> >      http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html
> >    So remove it until we figure out why.
> > 
> 
> Robert?

Will look at this.

> 
> > Also, is the value for "no such event" 0 or -1?  The perf_event_amd.c
> > file seems to use them interchangably from what I can tell.
> 
> 	val = hw_cache_event_ids[cache_type][cache_op][cache_result];
> 
> 	if (val == 0)
> 		return -ENOENT;
> 
> 	if (val == -1)
> 		return -EINVAL;
> 
> 
> But yeah, somewhat inconsistent. Robert, Andre, could you guys go over
> the AMD events some time?
> 

We will review all predefined events.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

