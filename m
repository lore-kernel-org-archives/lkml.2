Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0J2EWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:22:35 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56955 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0J2EWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:22:30 -0400
X-AuditID: b753bd60-a7da7ba000003e7d-6f-4cca4c03d22f
Message-ID: <4CCA4BFD.3020302@hitachi.com>
Date: Fri, 29 Oct 2010 13:22:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, fweisbec@gmail.com, rostedt@goodmis.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] call stop_machine_text_poke() on all cpus
References: <20101028152026.GB2875@redhat.com>
In-Reply-To: <20101028152026.GB2875@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/29 0:20), Jason Baron wrote:
> Currently, text_poke_smp() passes a NULL as the third argument to
> __stop_machine(), which will only run stop_machine_text_poke()
> on 1 cpu. Change NULL -> cpu_online_mask, as stop_machine_text_poke()
> is intended to be run on all cpus.

That should be my misunderstand...

> 
> I actually didn't notice any problems with stop_machine_text_poke()
> only being called on 1 cpu, but found this via code inspection.

Thank you very much!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/kernel/alternative.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 9f39a1c..3c3f26f 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -705,6 +705,6 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
>  	atomic_set(&stop_machine_first, 1);
>  	wrote_text = 0;
>  	/* Use __stop_machine() because the caller already got online_cpus. */
> -	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> +	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
>  	return addr;
>  }


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
