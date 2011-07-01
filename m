Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1GAN5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:57:50 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:24790
	"EHLO CH1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756475Ab1GAN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:57:48 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNNQS4-01-9U6-02
X-M-MSG: 
Date: Fri, 1 Jul 2011 15:57:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Francis Moreau <francis.moro@gmail.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
Message-ID: <20110701135738.GU4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
 <20110628105335.GA17199@erda.amd.com>
 <1309259105.6701.210.camel@twins>
 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
 <20110629103714.GM4590@erda.amd.com>
 <1309344655.6701.1054.camel@twins>
 <20110629141056.GN4590@erda.amd.com>
 <1309358386.6701.1307.camel@twins>
 <20110630124752.GS4590@erda.amd.com>
 <1309527416.12449.729.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309527416.12449.729.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.07.11 09:36:56, Peter Zijlstra wrote:
> On Thu, 2011-06-30 at 14:47 +0200, Robert Richter wrote:
> > 
> > It covers the case there the sampling period may be specified in the
> > raw config register (line 286). I know, this is not the preferred way,
> > but this way you can directly set the config value in perf without
> > bypassing some bits through event->attr. As IBS events are sampling
> > events I will change the code so that it writes back the specified
> > period to event->attr.sample_period/event->hw.sample_period. Something
> > like:
> > 
> >         if (event->hw.sample_period) {
> >                 ...
> >         } else {
> >                 max_cnt = event->attr.config & map->cnt_mask;
> >                 event->attr.sample_period = max_cnt << 4;
> >                 event->hw.sample_period = event->attr.sample_period;
> >         }
> > 
> > This will then proper identify IBS samples as samling event.
> 
> Ah, being a naught boy then ;-), yeah passing stuff through like that
> will confuse bits and the fixup you propose will indeed work around
> that.
> 
> But why complicate things like this? You just add extra code to the init
> path since you need to support attr.sample_period input as well.

For people who only want to set the raw register value as in the spec
it is much easier, they don't need to know perf internals. 3 lines of
code for this are okay.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

