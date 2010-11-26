Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0KZTm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:42:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0KZTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:42:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/14] freezer: remove superflous try_to_freeze() loop in do_signal_stop()
Date: Fri, 26 Nov 2010 20:42:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-4-git-send-email-tj@kernel.org>
In-Reply-To: <1290768569-16224-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262042.21444.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 26, 2010, Tejun Heo wrote:
> do_signal_stop() is used only by get_signal_to_deliver() and after a
> successful signal stop, it always calls try_to_freeze(), so the
> try_to_freeze() loop around schedule() in do_signal_stop() is
> superflous and confusing.  Remove it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks!

> ---
>  kernel/signal.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index fe004b5..0a6816a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1781,9 +1781,7 @@ static int do_signal_stop(int signr)
>  	}
>  
>  	/* Now we don't run again until woken by SIGCONT or SIGKILL */
> -	do {
> -		schedule();
> -	} while (try_to_freeze());
> +	schedule();
>  
>  	tracehook_finish_jctl();
>  	current->exit_code = 0;
> 

