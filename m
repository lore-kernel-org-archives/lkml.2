Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0LITYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:24:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:48234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab0LITYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:24:39 -0500
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291267223.2405.314.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 20:24:30 +0100
Message-ID: <1291922670.6803.47.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> +++ b/arch/x86/kernel/cpu/perf_event.c

> @@ -1362,6 +1357,7 @@ int __init init_hw_perf_events(void)
>  
>         switch (boot_cpu_data.x86_vendor) {
>         case X86_VENDOR_INTEL:
> +               init_uncore_pmu();
>                 err = intel_pmu_init();
>                 break;
>         case X86_VENDOR_AMD: 

Since you're otherwise fully separated from the regular cpu driver,
could you also grow your own early_initcall() ?
