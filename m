Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1J1C2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:28:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50201 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1J1C2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:28:47 -0400
X-AuditID: b753bd60-a32aeba0000019f4-bb-4eaa135c0e23
X-AuditID: b753bd60-a32aeba0000019f4-bb-4eaa135c0e23
Message-ID: <4EAA1357.8060802@hitachi.com>
Date: Fri, 28 Oct 2011 11:28:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: call stop_machine_text_poke() on all CPUs
References: <1319702072-32676-1-git-send-email-rabin@rab.in>
In-Reply-To: <1319702072-32676-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/27 16:54), Rabin Vincent wrote:
> It appears that stop_machine_text_poke() wants to be called on all CPUs,
> like it's done from text_poke_smp().  Fix text_poke_smp_batch() to do
> this.

cpu_mask==NULL finally falls back to cpu_online_mask, but even though
it should be specified correctly.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/x86/kernel/alternative.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index c638228..1f84794 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -738,5 +738,5 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
>  
>  	atomic_set(&stop_machine_first, 1);
>  	wrote_text = 0;
> -	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> +	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
>  }


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
