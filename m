Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2I1LdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:33:16 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50336 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2I1LdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <1348824500.3292.66.camel@twins>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	<1348806696-31170-2-git-send-email-andi@firstfloor.org>
	<1348821784.3292.50.camel@twins>
	<CABPqkBS1Crg7yHbzrvF7S2YUjrPZNSYRpE7tuax+OcEu4xrHMA@mail.gmail.com>
	<1348824500.3292.66.camel@twins>
Date: Fri, 28 Sep 2012 13:33:13 +0200
Message-ID: <CABPqkBQLmw7i65_kcpgfTcOuZDyeXCCUuHcGqkTZH6BMqEVALw@mail.gmail.com>
Subject: Re: [PATCH 01/31] perf, x86: Add PEBSv2 record support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-09-28 at 10:54 +0200, Stephane Eranian wrote:
>> On Fri, Sep 28, 2012 at 10:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
>> >> +               if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
>> >
>> > Shouldn't that be: && x86_pmu.intel_cap.pebs_trap, like most other sites
>> > instead? Or didn't they flip the trap capability on Haswell?
>>
>> On Haswell, you get the event_ip which points to the sampled
>> instruction, i.e., the off-by-one
>> error can be avoided by using that value instead of pebs.rip. The nice
>> side effect is that you
>> free the LBR and minimize the overhead (no fixups). Therfore the LBR
>> filter can have any
>> setting when combined with PEBS, thus we do not need to check for
>> compatibility nor force
>> any setting for the LBR filter.
>
> Yes I got that, but what good is that trap capability flag if they don't
> use it? Them adding a second u64 to the format to report it seems to
> suggest their trap capability is pointless, but nowhere has this been
> explained.

I suspect this trap field was only meaningful for P4. Since then, the
implementation has changed and I don't think this flag is relevant anymore.
To be cautious, you could always or this (pebs_fmt > 1 || trap).
