Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab2ITJBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:01:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51959 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2ITJBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:01:34 -0400
X-AuditID: b753bd60-94360ba000007c38-16-505adb6c2ffc
X-AuditID: b753bd60-94360ba000007c38-16-505adb6c2ffc
Message-ID: <505ADB6B.3070706@hitachi.com>
Date: Thu, 20 Sep 2012 18:01:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration
 properly
References: <1348062414-6578-1-git-send-email-bp@amd64.org>
In-Reply-To: <1348062414-6578-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/19 22:46), Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> I get
> 
> arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined [-Wunused-function]
> 
> on tip/auto-latest.
> 
> Hide the forward declaration in the KPROBES_CAN_USE_FTRACE as it
> is done in its callsites.

Thank you for reporting and fixing :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Ingo, please pull this.

Thank you,

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/kprobes.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index b7c2a85d1926..ac4188368fdf 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -541,8 +541,11 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
>  	return 1;
>  }
>  
> +#ifdef KPROBES_CAN_USE_FTRACE
>  static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
>  				      struct kprobe_ctlblk *kcb);
> +#endif
> +
>  /*
>   * Interrupts are disabled on entry as trap3 is an interrupt gate and they
>   * remain disabled throughout this function.
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


