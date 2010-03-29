Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0C2QtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:49:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:39579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0C2QtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:49:01 -0400
Subject: Re: [PATCH 3/3] perf/core, x86: implement ARCH_PERFMON_EVENTSEL
 bit masks
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269880612-25800-4-git-send-email-robert.richter@amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
	 <1269880612-25800-4-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 18:48:58 +0200
Message-ID: <1269881338.12097.361.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 18:36 +0200, Robert Richter wrote:
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -454,20 +454,7 @@ static __initconst u64 atom_hw_cache_event_ids
>  
>  static u64 intel_pmu_raw_event(u64 hw_event)
>  {
> -#define CORE_EVNTSEL_EVENT_MASK                0x000000FFULL
> -#define CORE_EVNTSEL_UNIT_MASK         0x0000FF00ULL
> -#define CORE_EVNTSEL_EDGE_MASK         0x00040000ULL
> -#define CORE_EVNTSEL_INV_MASK          0x00800000ULL
> -#define CORE_EVNTSEL_REG_MASK          0xFF000000ULL
> -
> -#define CORE_EVNTSEL_MASK              \
> -       (INTEL_ARCH_EVTSEL_MASK |       \
> -        INTEL_ARCH_UNIT_MASK   |       \
> -        INTEL_ARCH_EDGE_MASK   |       \
> -        INTEL_ARCH_INV_MASK    |       \
> -        INTEL_ARCH_CNT_MASK)
> -
> -       return hw_event & CORE_EVNTSEL_MASK;
> +       return hw_event & X86_RAW_EVENT_MASK;
>  } 

Could you fold this with your 2/3 and create x86_pmu_raw_event() which
lives in arch/x86/kernel/cpu/perf_event.c, that's more consistent wrt
the X86_RAW_EVENT_MASK name and that way you don't need to re-order the
#include ""s either.

