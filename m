Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0C2RBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:01:45 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41874
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752231Ab0C2RBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:01:42 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN936eM62a3Lab9bha706lzz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0L01ZAE-01-HUB-02
X-M-MSG: 
Date: Mon, 29 Mar 2010 19:01:13 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf/core, x86: implement ARCH_PERFMON_EVENTSEL
 bit masks
Message-ID: <20100329170113.GD11907@erda.amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
 <1269880612-25800-4-git-send-email-robert.richter@amd.com>
 <1269881338.12097.361.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1269881338.12097.361.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Mar 2010 17:01:15.0706 (UTC) FILETIME=[7188F9A0:01CACF61]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.03.10 18:48:58, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 18:36 +0200, Robert Richter wrote:
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -454,20 +454,7 @@ static __initconst u64 atom_hw_cache_event_ids
> >  
> >  static u64 intel_pmu_raw_event(u64 hw_event)
> >  {
> > -#define CORE_EVNTSEL_EVENT_MASK                0x000000FFULL
> > -#define CORE_EVNTSEL_UNIT_MASK         0x0000FF00ULL
> > -#define CORE_EVNTSEL_EDGE_MASK         0x00040000ULL
> > -#define CORE_EVNTSEL_INV_MASK          0x00800000ULL
> > -#define CORE_EVNTSEL_REG_MASK          0xFF000000ULL
> > -
> > -#define CORE_EVNTSEL_MASK              \
> > -       (INTEL_ARCH_EVTSEL_MASK |       \
> > -        INTEL_ARCH_UNIT_MASK   |       \
> > -        INTEL_ARCH_EDGE_MASK   |       \
> > -        INTEL_ARCH_INV_MASK    |       \
> > -        INTEL_ARCH_CNT_MASK)
> > -
> > -       return hw_event & CORE_EVNTSEL_MASK;
> > +       return hw_event & X86_RAW_EVENT_MASK;
> >  } 
> 
> Could you fold this with your 2/3 and create x86_pmu_raw_event() which
> lives in arch/x86/kernel/cpu/perf_event.c, that's more consistent wrt
> the X86_RAW_EVENT_MASK name and that way you don't need to re-order the
> #include ""s either.

Ah, yes. Will do this and resend the patches.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

