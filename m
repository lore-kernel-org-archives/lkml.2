Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2JOFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:25:56 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40863 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2JOFZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:25:54 -0400
Message-ID: <507B9E6B.9010208@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2012 10:56:03 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: acme@redhat.com, mingo@kernel.org, peterz@infradead.org,
        eranian@google.com, robert.richter@amd.com, asharma@fb.com,
        mpjohn@us.ibm.com, Anton Blanchard <anton@au1.ibm.com>,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
References: <20121012012839.GA15348@us.ibm.com>
In-Reply-To: <20121012012839.GA15348@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12101505-2000-0000-0000-000009792B02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 06:58 AM, Sukadev Bhattiprolu wrote:
> 
> From 89cb6a25b9f714e55a379467a832ee015014ed11 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Tue, 18 Sep 2012 10:59:01 -0700
> Subject: [PATCH] perf: Add a few generic stalled-cycles events
> 
> The existing generic event 'stalled-cycles-backend' corresponds to
> PM_CMPLU_STALL event in Power7. While this event is useful, detailed
> performance analysis often requires us to find more specific reasons
> for the stalled cycle. For instance, stalled cycles in Power7 can
> occur due to, among others:
> 
> 	- instruction fetch unit (IFU),
> 	- Load-store-unit (LSU),
> 	- Fixed point unit (FXU)
> 	- Branch unit (BRU)
> 
> While it is possible to use raw codes to monitor these events, it quickly
> becomes cumbersome with performance analysis frequently requiring mapping
> the raw event codes in reports to their symbolic names.
> 
> This patch is a proposal to try and generalize such perf events. Since
> the code changes are quite simple, I bunched all the 4 events together.
> 
> I am not familiar with how readily these events would map to other
> architectures. Here is some information on the events for Power7:
> 
> 	stalled-cycles-fixed-point (PM_CMPLU_STALL_FXU)
> 
> 		Following a completion stall, the last instruction to finish
> 		before completion resumes was from the Fixed Point Unit.
> 
> 		Completion stall is any period when no groups completed and
> 		the completion table was not empty for that thread.
> 
> 	stalled-cycles-load-store (PM_CMPLU_STALL_LSU)
> 
> 		Following a completion stall, the last instruction to finish
> 		before completion resumes was from the Load-Store Unit.
> 
> 	stalled-cycles-instruction-fetch (PM_CMPLU_STALL_IFU)
> 
> 		Following a completion stall, the last instruction to finish
> 		before completion resumes was from the Instruction Fetch Unit.
> 
> 	stalled-cycles-branch (PM_CMPLU_STALL_BRU)
> 
> 		Following a completion stall, the last instruction to finish
> 		before completion resumes was from the Branch Unit.
> 
> Looking for feedback on this approach and if this can be further extended.
> Power7 has 530 events[2] out of which a "CPI stack analysis"[1] uses about 26
> events.
> 
> 
> [1] CPI Stack analysis
> 	https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis
> 
> [2] Power7 events:
> 	https://www.power.org/documentation/comprehensive-pmu-event-reference-power7/

Here we should try to come up with a generic list of places in the processor where
the cycles can stall.

PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT
PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE
PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH
PERF_COUNT_HW_STALLED_CYCLES_BRANCH
PERF_COUNT_HW_STALLED_CYCLES_<ANY_OTHER_PLACE1>
PERF_COUNT_HW_STALLED_CYCLES_<ANY_OTHER_PLACE2>
PERF_COUNT_HW_STALLED_CYCLES_<ANY_OTHER_PLACE3>
-----------------------------------------------

This generic list can be a superset which can accommodate all the architecture
giving the flexibility to implement selectively there after. Stall locations are
very important from CPI analysis stand point with real world use cases. This will
definitely help us in that direction.

Regards
Anshuman

