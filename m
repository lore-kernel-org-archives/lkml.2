Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1HLSOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:14:06 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48523
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab1HLSOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:14:03 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPTUJW-01-GB4-02
X-M-MSG: 
Date: Fri, 12 Aug 2011 20:11:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] perf, x86: Implement 64 bit counter support for IBS
Message-ID: <20110812181145.GI11702@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-8-git-send-email-robert.richter@amd.com>
 <1312285040.1147.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1312285040.1147.108.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.11 07:37:20, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > +       /*
> > +        * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
> > +        * supported in all cpus. As this triggered an interrupt, we
> > +        * set the current count to the max count.
> > +        */
> > +       config = buffer[0];
> > +       if (perf_ibs == &perf_ibs_op) {
> > +               config &= ~IBS_OP_CUR_CNT;
> > +               config |= (config & IBS_OP_MAX_CNT) << 36;
> > +       } 
> 
> Shouldn't that be conditional on capability muck?

It doesn't hurt actually, but true, will implement it right with the
capability check.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

