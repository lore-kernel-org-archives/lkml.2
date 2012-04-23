Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2DWKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:08:42 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:48846
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599Ab2DWKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:08:41 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2XG6B-01-8R8-02
X-M-MSG: 
Date: Mon, 23 Apr 2012 12:08:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120423100832.GT9747@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
 <1334399098.2528.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334399098.2528.52.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.04.12 12:24:58, Peter Zijlstra wrote:
> On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
> > +       switch (event->attr.type) {
> > +       case PERF_TYPE_HARDWARE:
> > +               switch (event->attr.config) {
> > +               case PERF_COUNT_HW_CPU_CYCLES:
> > +                       *config = 0;
> > +                       return 0;
> > +               }
> > +               break;
> > +       case PERF_TYPE_RAW:
> > +               switch (event->attr.config) {
> > +               case 0x0076:
> > +                       *config = 0;
> > +                       return 0;
> > +               case 0x00C1:
> > +                       *config = IBS_OP_CNT_CTL;
> > +                       return 0;
> > +               }
> > +               break;
> > +       default:
> > +               return -ENOENT;
> > +       } 
> 
> Another option would be to do this from amd_pmu_hw_config() after you've
> already gotten rid of the whole attr.type thing.

I didn't want to have IBS setup code in amd_pmu_hw_config(). The
approach to pass the configuration for precise sampling to the ibs pmu
was the simplest to me.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

