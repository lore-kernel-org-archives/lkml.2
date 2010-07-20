Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0GTExz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:53:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46070 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0GTExy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:53:54 -0400
X-AuditID: b753bd60-a9cd2ba000005dcc-ab-4c452bdf40d4
Message-ID: <4C452BD6.7080901@hitachi.com>
Date: Tue, 20 Jul 2010 13:53:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kprobes: fix swapped segment registers in kretprobe
References: <20100718221111.19BC24B2C9@magilla.sf.frob.com>
In-Reply-To: <20100718221111.19BC24B2C9@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> The following changes since commit bea9a6d239cb2aa2ced4dcb0a05e1827ce61fa3d:
> 
>   Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 (2010-07-18 10:09:25 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/kprobes
> 
> Roland McGrath (1):
>       x86: kprobes: fix swapped segment registers in kretprobe
> 
>  arch/x86/kernel/kprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> Thanks,
> Roland
> ---
> [PATCH] x86: kprobes: fix swapped segment registers in kretprobe
> 
> In commit f007ea26, the order of the %es and %ds segment registers
> got accidentally swapped, so synthesized 'struct pt_regs' frames
> have the two values inverted.  It's almost sure that these values
> never matter, and that they also never differ.  But wrong is wrong.

Oops, thanks Roland for finding it.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/kernel/kprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 345a4b1..675879b 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -640,8 +640,8 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  	/* Skip cs, ip, orig_ax and gs. */	\
>  	"	subl $16, %esp\n"	\
>  	"	pushl %fs\n"		\
> -	"	pushl %ds\n"		\
>  	"	pushl %es\n"		\
> +	"	pushl %ds\n"		\
>  	"	pushl %eax\n"		\
>  	"	pushl %ebp\n"		\
>  	"	pushl %edi\n"		\
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

