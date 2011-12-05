Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1LEVih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:38:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:38846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab1LEVig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:38:36 -0500
Message-ID: <1323121074.32012.40.camel@twins>
Subject: Re: [PATCH 09/12] perf_events: add hook to flush branch_stack on
 context switch (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 22:37:54 +0100
In-Reply-To: <1318595833-29984-10-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-10-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> +               /*
> +                * check if the context has at least one
> +                * event using PERF_SAMPLE_BRANCH_STACK
> +                */
> +               if (cpuctx->ctx.nr_branch_stack > 0
> +                   && pmu->flush_branch_stack) {
> +
> +                       pmu = cpuctx->ctx.pmu;
> +
> +                       perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +                       perf_pmu_disable(pmu);
> +
> +                       pmu->flush_branch_stack();
> +
> +                       perf_pmu_enable(pmu);
> +
> +                       perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +               }
> +       } 

(what whitespace looks funny)

So all PMUs not supporting this branch stuff will fail to create a
has_branch_stack() event, right? Thus all ctx with !0 nr_branch_stack
support it. Doesn't this make the test for pmu->flush_branch_stack
redundant?


