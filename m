Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab1IJInJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 04:43:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47056 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab1IJInH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 04:43:07 -0400
X-AuditID: b753bd60-a3cafba0000019f4-b6-4e6b2319d621
X-AuditID: b753bd60-a3cafba0000019f4-b6-4e6b2319d621
Message-ID: <4E6B2315.8000202@hitachi.com>
Date: Sat, 10 Sep 2011 17:43:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        namhyung@gmail.com, jolsa@redhat.com, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] arch/x86/kernel/kprobes.c: quiet sprase noise about external
 linkage
References: <201109091559.58280.hartleys@visionengravers.com>
In-Reply-To: <201109091559.58280.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/10 7:59), H Hartley Sweeten wrote:
> The function arch_unoptimize_kprobes is already declared extern in
> <linux/kprobes.h>. The actual function should not be marked as extern.
> This quiets the following sparse noise:
> 
> warning: function 'arch_unoptimize_kprobes' with external linkage has definition

Right, there is no reason to mark it extern.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> 
> ---
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index f1a6244..e8d5903 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1483,8 +1483,8 @@ static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
>   * Recover original instructions and breakpoints from relative jumps.
>   * Caller must call with locking kprobe_mutex.
>   */
> -extern void arch_unoptimize_kprobes(struct list_head *oplist,
> -				    struct list_head *done_list)
> +void arch_unoptimize_kprobes(struct list_head *oplist,
> +			     struct list_head *done_list)
>  {
>  	struct optimized_kprobe *op, *tmp;
>  	int c = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
