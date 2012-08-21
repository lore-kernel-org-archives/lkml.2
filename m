Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2HUKqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:46:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:41325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2HUKqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:46:35 -0400
Message-ID: <1345545978.23018.104.camel@twins>
Subject: Re: [PATCH] perf/x86: fix SNB-EP CBO and PCU uncore PMU filter
 management
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        zheng.z.yan@intel.com
Date: Tue, 21 Aug 2012 12:46:18 +0200
In-Reply-To: <20120820162237.GA9295@quad>
References: <20120820162237.GA9295@quad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 18:22 +0200, Stephane Eranian wrote:
>         .constraints            = snbep_uncore_cbox_constraints,
>         .ops                    = &snbep_uncore_msr_ops,
>         .format_group           = &snbep_uncore_cbox_format_group,
> +       .extra_regs             = snbep_uncore_cbo_extra_regs, 

The whole cbo vs cbox thing is a bit unfortunate, I know Intel tends to
forget to type the last letter, but could we be consistent?

Ideally Intel would have called the thing a Cache Coherence Unit or
somesuch to match the Power Control Unit, But seeing its called C-Box, I
don't see the point of saving the 1 character and obfuscate the name.
I've even seen CBO Box used, which is of course completely ridiculous.
