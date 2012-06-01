Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab2FARzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:55:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4911 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979Ab2FARzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:55:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6729"; a="196873068"
Date: Fri, 1 Jun 2012 12:55:30 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 17/20] hexagon: Do not call try_to_freeze() in
 do_signal()
Message-ID: <20120601175530.GB23541@codeaurora.org>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
 <1337983476-22081-17-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337983476-22081-17-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:04:33AM +0200, Richard Weinberger wrote:
> get_signal_to_deliver() already calls try_to_freeze(), there is no
> need to call it directly.
> 
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/hexagon/kernel/signal.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
> index 8403bfd..9783cfa 100644
> --- a/arch/hexagon/kernel/signal.c
> +++ b/arch/hexagon/kernel/signal.c
> @@ -20,7 +20,6 @@
>  
>  #include <linux/linkage.h>
>  #include <linux/syscalls.h>
> -#include <linux/freezer.h>
>  #include <linux/tracehook.h>
>  #include <linux/irqflags.h>
>  #include <asm/registers.h>
> @@ -210,9 +209,6 @@ static void do_signal(struct pt_regs *regs)
>  	if (!user_mode(regs))
>  		return;
>  
> -	if (try_to_freeze())
> -		goto no_signal;
> -
>  	signo = get_signal_to_deliver(&info, &sigact, regs, NULL);
>  
>  	if (signo > 0) {
> @@ -237,7 +233,6 @@ static void do_signal(struct pt_regs *regs)
>  		return;
>  	}
>  
> -no_signal:
>  	/*
>  	 * If we came from a system call, handle the restart.
>  	 */
> -- 
> 1.7.7.3
> 

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
