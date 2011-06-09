Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1FIUpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:45:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32946 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1FIUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:45:11 -0400
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an
 extra reg (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <BANLkTimSO-+-0=bc=TZqvUxe7gwsSn1xRg@mail.gmail.com>
References: <20110606145708.GA7279@quad> <1307644812.2497.1022.camel@laptop>
	 <BANLkTimSO-+-0=bc=TZqvUxe7gwsSn1xRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 22:48:47 +0200
Message-ID: <1307652527.2497.1024.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 22:36 +0200, Stephane Eranian wrote:
> On Thu, Jun 9, 2011 at 8:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-06-06 at 16:57 +0200, Stephane Eranian wrote:
> >> +static struct cpu_hw_events *allocate_fake_cpuc(void)
> >> +{
> >> +       struct cpu_hw_events *cpuc;
> >> +       int cpu = smp_processor_id();
> >
> > That's a boo-boo, clearly we are in a preemptible context here (see the
> > GFP_KERNEL allocation on the next line), so using smp_processor_id()
> > isn't valid.
> >
> Good point. I missed that.

Yeah, I did too, Ingo found it during testing.

> > Now since all that allocate_shared_regs() does with it is pick a NUMA
> > node, we should probably use raw_smp_processor_id() and leave it at
> > that, right?
> >
> Yeah, for what we do with fake_cpuc, it does not really matter where
> it comes from. This is not on any critical path. The simplest allocator
> will do it.

OK, fixed that up.

