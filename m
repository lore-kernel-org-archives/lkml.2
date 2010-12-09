Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0LIU1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:27:31 -0500
Received: from smtp-out.google.com ([74.125.121.35]:18396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab0LIU1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BrgFn7fPeeV2Le7oyY1ES8xhX1Iiwl+0ygS6IS/F20pU+Uvdaeyk/mk/K+1kIcxQNh
         cSv4USCujUnUeIVtljMA==
MIME-Version: 1.0
In-Reply-To: <1291925943.6803.50.camel@twins>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	<1291922467.6803.44.camel@twins>
	<AANLkTi=GeCHZ23J5UDoUfbWnLHfVWCeA7f9Gh_sKYSqa@mail.gmail.com>
	<1291925943.6803.50.camel@twins>
Date: Thu, 9 Dec 2010 21:27:26 +0100
Message-ID: <AANLkTikDxCRRo_NVngs3E0NW0dXsdJdNYSXehKpz2dgz@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 9:19 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-12-09 at 21:15 +0100, Stephane Eranian wrote:
>> On Thu, Dec 9, 2010 at 8:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
>> >> +       /* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
>> >> +       family = boot_cpu_data.x86;
>> >> +       model = boot_cpu_data.x86_model;
>> >> +       if (family != 6 || (model != 0x1A && model != 0x1E && model != 0x1F))
>> >> +               return;
>> >
>> > So that's 26, 30 and 31? Curiously
>> > arch/x86/kernel/cpu/perf_event_intel.c does have 31.
>
> That was clearly meant to say: doesn't.. Does Intel have an exhaustive
> model list somewhere?
>
>> It is also missing model 44 (0x2c).
>
Uncore logic in the same on NHM and WSM.
Events may be different but I have not see a
public document that describes that.

> Right.. but if the westmere uncore is the same, then its also missing
> 37.
>
yes, 37 is also missing.

> The -EX chips have a different uncore, right?
>
True. I don't know if the programming is completely different
but it would not surprise me.
Documentation is at:
http://www.intel.com/assets/en_US/pdf/designguide/323535.pdf
