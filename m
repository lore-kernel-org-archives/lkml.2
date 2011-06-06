Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1FFPSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:18:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab1FFPSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:18:45 -0400
Date: Mon, 6 Jun 2011 17:18:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide
 debug options
Message-ID: <20110606151832.GI30348@elte.hu>
References: <20110605210223.GA7595@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605210223.GA7595@leaf>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> Several debugging options currently default to y, such as
> CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> want to turn those options off to save space; however, turning them off
> requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> CONFIG_EXPERT exists specifically to unhide options potentially needed
> by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> CONFIG_DEBUG_KERNEL.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> Revised as requested by Ingo Molnar.
> 
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index ebafac4..5e482a3 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -909,6 +909,7 @@ config ANON_INODES
>  
>  menuconfig EXPERT
>  	bool "Configure standard kernel features (expert users)"
> +	select DEBUG_KERNEL
>  	help
>  	  This option allows certain base kernel options and settings
>            to be disabled or tweaked. This is for specialized

So now that it's selected, mind removing the superfluous EXPERT bits 
from the Kconfig files that have it?

Thanks,

	Ingo
