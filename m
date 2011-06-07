Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab1FGFVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:21:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42270 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750705Ab1FGFVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:21:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/3889ZABj3T84YMD8nUQ1Fa6FmxxKbDdd+iqqGNw
	rtpLbIhis0NX6B
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1307350909.2353.7408.camel@twins>
References: <20110605151323.GA30590@elte.hu>
	 <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu>
	 <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de>
	 <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>
	 <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu>
	 <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>
	 <4DEBE3DF.70104@die-jansens.de>  <1307350909.2353.7408.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 07:20:55 +0200
Message-ID: <1307424055.7472.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 11:01 +0200, Peter Zijlstra wrote:
> On Sun, 2011-06-05 at 22:15 +0200, Arne Jansen wrote:
> > 
> > Can lockdep just get confused by the lockdep_off/on calls in printk
> > while scheduling is allowed? There aren't many users of lockdep_off().
> 
> Yes!, in that case lock_is_held() returns false, triggering the warning.
> I guess there's an argument to be made in favour of the below..

I've been testing/rebooting for a couple hours now, x3550 M3 lockup woes
using Arne's config are history.

All-better-by: (nah, heel sense-o-humor, _down_ i say;)
  
> ---
>  kernel/lockdep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 53a6895..e4129cf 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3242,7 +3242,7 @@ int lock_is_held(struct lockdep_map *lock)
>  	int ret = 0;
>  
>  	if (unlikely(current->lockdep_recursion))
> -		return ret;
> +		return 1; /* avoid false negative lockdep_assert_held */
>  
>  	raw_local_irq_save(flags);
>  	check_flags(flags);
> 


