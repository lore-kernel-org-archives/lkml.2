Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab2FARzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:55:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4712 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961Ab2FARzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:55:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6729"; a="196872747"
Date: Fri, 1 Jun 2012 12:54:59 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 05/20] hexagon: Do not call do_signal() with irqs
 disabled
Message-ID: <20120601175459.GA23541@codeaurora.org>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
 <1337983476-22081-5-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337983476-22081-5-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:04:21AM +0200, Richard Weinberger wrote:
> get_signal_to_deliver() calls try_to_freeze() which might sleep.
> 
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/hexagon/kernel/signal.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
> index 434866e..8403bfd 100644
> --- a/arch/hexagon/kernel/signal.c
> +++ b/arch/hexagon/kernel/signal.c
> @@ -22,6 +22,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/freezer.h>
>  #include <linux/tracehook.h>
> +#include <linux/irqflags.h>
>  #include <asm/registers.h>
>  #include <asm/thread_info.h>
>  #include <asm/unistd.h>
> @@ -267,6 +268,8 @@ no_restart:
>  
>  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
>  {
> +	local_irq_enable();
> +
>  	if (thread_info_flags & _TIF_SIGPENDING)
>  		do_signal(regs);
>  
> -- 
> 1.7.7.3
> 

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
