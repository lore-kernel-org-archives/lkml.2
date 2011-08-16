Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1HPRnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab1HPRnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:43:41 -0400
Date: Tue, 16 Aug 2011 19:40:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 33/41] xtensa: Don't reimplement force_sigsegv()
Message-ID: <20110816174051.GG29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-34-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-34-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> Instead of open coding the sequence from force_sigsegv() just call
> it. This also fixes a race because sa_handler was being modified
> without holding ->sighand->siglock.

The same problem with the changelog in this and the next patch.

The patch itself looks nice.

> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Chris Zankel <chris@zankel.net>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/xtensa/kernel/signal.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
> index f2220b5..4f53770 100644
> --- a/arch/xtensa/kernel/signal.c
> +++ b/arch/xtensa/kernel/signal.c
> @@ -425,9 +425,7 @@ static void setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	return;
>  
>  give_sigsegv:
> -	if (sig == SIGSEGV)
> -		ka->sa.sa_handler = SIG_DFL;
> -	force_sig(SIGSEGV, current);
> +	force_sigsegv(sig, current);
>  }
>  
>  /*
> -- 
> 1.7.4.4
> 

