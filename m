Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1ETDTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:19:01 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53095 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1ETDTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:19:00 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK936eK1432N98dK4015Lzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLH57H-01-6J2-02
X-M-MSG: 
Date: Fri, 20 May 2011 05:18:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110520031855.GA17196@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <20110419102600.GU31407@erda.amd.com>
 <1305753398.2466.7180.camel@twins>
 <20110518212054.GC28476@elte.hu>
 <1305754613.2466.7190.camel@twins>
 <20110519180650.GC6139@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110519180650.GC6139@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.05.11 14:06:50, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2011-05-18 at 23:20 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > >                         if (c->weight != w)
> > > > >                                 continue;
> > > > >  
> > > > > -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> > > > > -                               if (!test_bit(j, used_mask))
> > > > > +                       /* for each bit in idxmsk starting from idx */
> > > > > +                       while (idx < X86_PMC_IDX_MAX) {
> > > > > +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> > > > > +                                                   idx);
> > > > 
> > > > I'd be mighty tempted to ignore that 80 column rule here ;-)
> > > 
> > > Please put the body of the loop into a helper function, the function is large 
> > > and there are countless col80 uglinesses in it!
> > 
> > I just tried that, its real ugly due to the amount of state you need to
> > pass around.
> 
> Does it help if you put that state into a helper structure?

Yes, this is what I have in mind too. We could iterate on such a state
stucture instead of a couple of single variables. Storing and
restoring the state will then just copying the structure.

-Robert


> 
> Thanks,
> 
> 	Ingo
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

