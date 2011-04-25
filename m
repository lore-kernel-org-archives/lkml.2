Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab1DYKiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:38:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248Ab1DYKiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:38:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] freezer: use smp barriers
Date: Mon, 25 Apr 2011 12:38:35 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
References: <1303716665-27584-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1303716665-27584-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201104251238.36005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 25, 2011, Mike Frysinger wrote:
> The freezer processes are dealing with multiple threads running
> simultaneously, and on a UP system, the memory reads/writes do
> not need barriers to keep things in sync.  These are only needed
> on SMP systems, so use SMP barriers instead.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  kernel/freezer.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 66ecd2e..7b01de9 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -17,7 +17,7 @@ static inline void frozen_process(void)
>  {
>  	if (!unlikely(current->flags & PF_NOFREEZE)) {
>  		current->flags |= PF_FROZEN;
> -		wmb();
> +		smp_wmb();
>  	}
>  	clear_freeze_flag(current);
>  }
> @@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
>  	 * the task as frozen and next clears its TIF_FREEZE.
>  	 */
>  	if (!freezing(p)) {
> -		rmb();
> +		smp_rmb();
>  		if (frozen(p))
>  			return false;
>  
> 

