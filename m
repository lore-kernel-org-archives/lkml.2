Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1DRRoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:44:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51064 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080Ab1DRRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:44:03 -0400
Subject: Re: [PATCH] Fix infinite loop in ARM user perf_event backtrace code
From: Will Deacon <will.deacon@arm.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Jamie Iles <jamie@jamieiles.com>, olofj@chromium.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
References: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 18:42:24 +0100
Message-ID: <1303148544.13157.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonny,

On Sat, 2011-04-16 at 04:27 +0100, Sonny Rao wrote:
> The ARM user backtrace code can get into an infinite loop if it
> runs into an invalid stack frame which points back to itself.
> This situation has been observed in practice.  Fix it by capping
> the number of entries in the backtrace.  This is also what other
> architectures do in their backtrace code.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  arch/arm/kernel/perf_event.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 69cfee0..1e61d60 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -746,7 +746,8 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
> 
>         tail = (struct frame_tail __user *)regs->ARM_fp - 1;
> 
> -       while (tail && !((unsigned long)tail & 0x3))
> +       while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
> +              tail && !((unsigned long)tail & 0x3))
>                 tail = user_backtrace(tail, entry);
>  }

Ok. Please can you put this into Russell's patch system?

Will

