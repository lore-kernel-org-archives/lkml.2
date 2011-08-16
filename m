Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1HPRXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1HPRXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:23:02 -0400
Date: Tue, 16 Aug 2011 19:20:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
Message-ID: <20110816172010.GC29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-13-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-13-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> Instead of open coding the sequence from force_sigsegv() just call
> it. This also fixes a race because sa_handler was being modified
> without holding ->sighand->siglock.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/microblaze/kernel/signal.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
> index 5996711..90de06d 100644
> --- a/arch/microblaze/kernel/signal.c
> +++ b/arch/microblaze/kernel/signal.c
> @@ -270,9 +270,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	return;
>  
>  give_sigsegv:
> -	if (sig == SIGSEGV)
> -		ka->sa.sa_handler = SIG_DFL;
> -	force_sig(SIGSEGV, current);
> +	force_sigsegv(sig, current);
>  }

This and the next patch seem to have the same problems with the
changelogs as 18 and 19.

13-14 looks correct to me...

Oleg.

