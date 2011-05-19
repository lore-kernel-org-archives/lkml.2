Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1ESKtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:49:10 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:47476
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177Ab1ESKtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:49:08 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK936eK1432N98dKzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLFVDR-01-NHM-02
X-M-MSG: 
Date: Thu, 19 May 2011 12:49:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110519104901.GC12404@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <20110419102600.GU31407@erda.amd.com>
 <1305753398.2466.7180.camel@twins>
 <20110518212054.GC28476@elte.hu>
 <1305754613.2466.7190.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305754613.2466.7190.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.05.11 17:36:53, Peter Zijlstra wrote:
> On Wed, 2011-05-18 at 23:20 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > >                         if (c->weight != w)
> > > >                                 continue;
> > > >  
> > > > -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> > > > -                               if (!test_bit(j, used_mask))
> > > > +                       /* for each bit in idxmsk starting from idx */
> > > > +                       while (idx < X86_PMC_IDX_MAX) {
> > > > +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> > > > +                                                   idx);
> > > 
> > > I'd be mighty tempted to ignore that 80 column rule here ;-)
> > 
> > Please put the body of the loop into a helper function, the function is large 
> > and there are countless col80 uglinesses in it!
> 
> I just tried that, its real ugly due to the amount of state you need to
> pass around.

I will try to improve the patch and send a new version.

Thanks for review.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

