Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1F0LYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:24:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43424 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab1F0LXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:23:20 -0400
Subject: Re: [patch] perf_events: more wrong events for AMD fam10h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 13:22:20 +0200
Message-ID: <1309173740.6701.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:39 -0400, Vince Weaver wrote:
> Hello
> 
> I'm in the process of auditing perf_event's awesome "generalized events".
> 
> On AMD fam10h for some we have the following definitions:
>   cache-references = INSTRUCTION_CACHE_FETCHES	0x530080
>   cache-misses 	   = INSTRUCTION_CACHE_MISSES	0x530081
> 
> on Intel at least I'm pretty sure these events match to Last Level Cache 
> accesses/misses, not icache.  Is there a reason for this?
> 
> Attached is a patch that removes these until better events can be found.
> (LLC is tricky on AMD as it's a shared resource).
> 
> Note, l1-dcache-stores is broken too, I'm looking into it.
> 
> Thanks,
> 
> Vince
> vweaver1@eecs.utk.edu
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index fe29c1d..a46b987 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -98,8 +98,6 @@ static const u64 amd_perfmon_event_map[] =
>  {
>    [PERF_COUNT_HW_CPU_CYCLES]			= 0x0076,
>    [PERF_COUNT_HW_INSTRUCTIONS]			= 0x00c0,
> -  [PERF_COUNT_HW_CACHE_REFERENCES]		= 0x0080,
> -  [PERF_COUNT_HW_CACHE_MISSES]			= 0x0081,

Would 0x40000F7E0 and 0x40000F7E1 be better?

>    [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]		= 0x00c2,
>    [PERF_COUNT_HW_BRANCH_MISSES]			= 0x00c3,
>    [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x00d0, /* "Decoder empty" event */

