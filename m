Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0LMQvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:51:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55441 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab0LMQvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:51:11 -0500
Date: Mon, 13 Dec 2010 17:51:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
Message-ID: <20101213165106.GC11449@basil.fritz.box>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
 <1291922467.6803.44.camel@twins>
 <AANLkTinanAQYQvwtowTzJ0bpLRUvp-5sqF6M9PoMSJR-@mail.gmail.com>
 <1291978036.6803.95.camel@twins>
 <AANLkTin7Jd=4boSH8Ge79e5g-j7EwE-AL81+1kHyNSL3@mail.gmail.com>
 <1292228848.10384.107.camel@minggr.sh.intel.com>
 <AANLkTimkXFaB2+zB41-OhWDWu=htvm0UJAoLBJhRvEPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimkXFaB2+zB41-OhWDWu=htvm0UJAoLBJhRvEPg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If think there you want something like:
> 
> if (cpu == cpumask_first(topology_core_siblings(cpu)) {
>       rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
>      wrmsrl(MSR_IA32_DEBUGCTLMSR, val | DEBUGCTLMSR_ENABLE_UNCORE_PMI);
> }

You have to be careful with hotplug. The code would need to be rerun
on hotplug. Otherwise the interrupt may end up on a downed CPU.
-Andi
