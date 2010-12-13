Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0LMTEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:04:10 -0500
Received: from smtp-out.google.com ([74.125.121.35]:43384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0LMTEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PDHaqMjRnZuHUsefjPBsx998jJEp/DwGNCgJT/0mrslQC2RiXAs4qY1K67HvlmO4lT
         imGBtK7ooO2D6LXCCBzA==
MIME-Version: 1.0
In-Reply-To: <20101213165106.GC11449@basil.fritz.box>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	<1291922467.6803.44.camel@twins>
	<AANLkTinanAQYQvwtowTzJ0bpLRUvp-5sqF6M9PoMSJR-@mail.gmail.com>
	<1291978036.6803.95.camel@twins>
	<AANLkTin7Jd=4boSH8Ge79e5g-j7EwE-AL81+1kHyNSL3@mail.gmail.com>
	<1292228848.10384.107.camel@minggr.sh.intel.com>
	<AANLkTimkXFaB2+zB41-OhWDWu=htvm0UJAoLBJhRvEPg@mail.gmail.com>
	<20101213165106.GC11449@basil.fritz.box>
Date: Mon, 13 Dec 2010 20:04:05 +0100
Message-ID: <AANLkTi=TL0SD-RA196+YK7Md9biQf9F2ird-kOHfgoNP@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 5:51 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> If think there you want something like:
>>
>> if (cpu == cpumask_first(topology_core_siblings(cpu)) {
>>       rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
>>      wrmsrl(MSR_IA32_DEBUGCTLMSR, val | DEBUGCTLMSR_ENABLE_UNCORE_PMI);
>> }
>
> You have to be careful with hotplug. The code would need to be rerun
> on hotplug. Otherwise the interrupt may end up on a downed CPU.

That is true.
