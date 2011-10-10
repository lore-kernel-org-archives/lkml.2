Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1JJGLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:11:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42518 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1JJGLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:11:13 -0400
Date: Mon, 10 Oct 2011 08:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov,
        "masami.hiramatsu.pt" <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
Message-ID: <20111010060810.GF32173@elte.hu>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
 <1317912555-9559-8-git-send-email-eranian@google.com>
 <20111006153229.GJ14482@one.firstfloor.org>
 <1317919424.29658.13.camel@twins>
 <20111006171412.GK14482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006171412.GK14482@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Oct 06, 2011 at 06:43:44PM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-10-06 at 17:32 +0200, Andi Kleen wrote:
> > > > +	kernel_insn_init(&insn, kaddr);
> > > > +	insn_get_opcode(&insn);
> > > 
> > > This makes me uncomfortable. AFAIK that's the first use of the opcode
> > > decoder being used directly for user space. It has a quite large attack
> > > surface. Who says it cannot be exploited?
> > 
> > You mean:
> > arch/x86/kernel/cpu/perf_event_intel_ds.c:intel_pmu_pebs_fixup_ip()
> > doesn't use the opcode decoder on user space code?
> 
> True it does. Ok the second.

That's what matters.

> I know uprobes is planning it too, so the problem has to be handled
> eventually.
> 
> Still it makes me uncomfortable.

FUD is not how we approach these things - you need to say something 
specific.

Thanks,

	Ingo
