Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2HULpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:45:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36607 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2HULpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <1345545978.23018.104.camel@twins>
References: <20120820162237.GA9295@quad>
	<1345545978.23018.104.camel@twins>
Date: Tue, 21 Aug 2012 13:45:48 +0200
Message-ID: <CABPqkBR3JP5_PskQ1xvLg_0RzZfH0qyz1sHeqya+Ok4V-sbrXQ@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: fix SNB-EP CBO and PCU uncore PMU filter management
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-08-20 at 18:22 +0200, Stephane Eranian wrote:
>>         .constraints            = snbep_uncore_cbox_constraints,
>>         .ops                    = &snbep_uncore_msr_ops,
>>         .format_group           = &snbep_uncore_cbox_format_group,
>> +       .extra_regs             = snbep_uncore_cbo_extra_regs,
>
> The whole cbo vs cbox thing is a bit unfortunate, I know Intel tends to
> forget to type the last letter, but could we be consistent?
>
> Ideally Intel would have called the thing a Cache Coherence Unit or
> somesuch to match the Power Control Unit, But seeing its called C-Box, I
> don't see the point of saving the 1 character and obfuscate the name.
> I've even seen CBO Box used, which is of course completely ridiculous.

Ok, I can resubmit with the word cbox instead.

Still missing is the HA box opcode match/mask support.
