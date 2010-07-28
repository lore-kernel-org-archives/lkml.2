Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0G1VR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:17:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65505 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0G1VR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MoOp5C/RU6AZKCgj3l11wZrkpZNHf5AoGh91048wTUAU1ly3L+l318UmhoWqcW+7s2
         M2O6Y3umNtSXwUEQYbzTio/ygSiPfjjaNk+rf3kaLleVLPHy4nHeAzrppzcndBvgrDGm
         YuIdvrd9vCk/YJ3T3iorO2eEfAH/4kJCh+gSY=
Date: Wed, 28 Jul 2010 23:17:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [GIT PULL] kgdb regression fixes for 2.6.35-rc5
Message-ID: <20100728211725.GF5394@nowhere>
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 03:39:49PM -0500, Jason Wessel wrote:
> Linus, please pull the for_linus branch for 2.6.35-rc6.  
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus
> 
> The kgdb validation tests found a regression where HW breakpoints
> stopped working with kdb / kgdb.  The problem was bisected and after
> talking with Frederic Weisbecker a patch was generated to repair the
> regression.
> 
> Thanks,
> Jason.
> 
> 
> ---
> Jason Wessel (1):
>       x86,kgdb: Fix hw breakpoint regression
> 
>  arch/x86/kernel/kgdb.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)



I'm sorry I spot it a bit late.
There is a little issue in this patch, irqs won't
be restored:

@@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
        if (!kgdb_io_module_registered)
                return NOTIFY_DONE;
 
+       local_irq_save(flags);
        return __kgdb_notify(&args, cmd);
+       local_irq_restore(flags);
 }

