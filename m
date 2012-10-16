Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2JPKIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:08:21 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:26075
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab2JPKIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:08:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(z1039oz98dI1432Izz1202h1d1ah1d2ahzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1155h)
X-WSS-ID: 0MBZDHL-02-0LL-02
X-M-MSG: 
Date: Tue, 16 Oct 2012 12:08:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: <acme@redhat.com>, <mingo@kernel.org>, <peterz@infradead.org>,
        <eranian@google.com>, <asharma@fb.com>,
        Anton Blanchard <anton@au1.ibm.com>, <paulus@samba.org>,
        <mpjohn@us.ibm.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
Message-ID: <20121016100809.GS8285@erda.amd.com>
References: <20121012012839.GA15348@us.ibm.com>
 <20121015155534.GR8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121015155534.GR8285@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev,

On 15.10.12 17:55:34, Robert Richter wrote:
> On 11.10.12 18:28:39, Sukadev Bhattiprolu wrote:
> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT },
> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE },
> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH },
> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BRANCH },
> 
> Instead of adding new hardware event types I would prefer to use raw
> events in conjunction with sysfs, see e.g. the intel-uncore
> implementation. Something like:
> 
>  $ find /sys/bus/event_source/devices/cpu/events/
>  ...
>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-fixed-point
>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-load-store
>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-instruction-fetch
>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-branch
>  ...
>  $ cat /sys/bus/event_source/devices/cpu/events/stalled-cycles-fixed-point
>  event=0xff,umask=0x00
> 
> Perf tool works then out-of-the-box with:
> 
>  $ perf record -e cpu/stalled-cycles-fixed-point/ ...

I refer here to arch/x86/kernel/cpu/perf_event_intel_uncore.c (should
be in v3.7-rc1 or tip:perf/core). See the INTEL_UNCORE_EVENT_DESC()
macro and 'if (type->event_descs) ...' in uncore_type_init(). The code
should be reworked to be non-architectural.

PMU registration is implemented for a longer time already for all
architectures and pmu types:

 /sys/bus/event_source/devices/*

But

 /sys/bus/event_source/devices/*/events/

exists only for a small number of pmus. Perf tool support of this was
implemented with:

 a6146d5 perf/tool: Add PMU event alias support

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

