Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1FEJiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:38:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab1FEJiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:38:15 -0400
Date: Sun, 5 Jun 2011 11:38:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unhide DEBUG_RODATA if EXPERT, even if DEBUG_KERNEL=n
Message-ID: <20110605093807.GB19927@elte.hu>
References: <20110605083739.GA18560@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605083739.GA18560@leaf>
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

> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -81,7 +81,7 @@ config X86_PTDUMP
>  config DEBUG_RODATA
>  	bool "Write protect kernel read-only data structures"
>  	default y
> -	depends on DEBUG_KERNEL
> +	depends on DEBUG_KERNEL || EXPERT

This is doing it the wrong way around. The right solution is what i 
wrote for verbose-debug: if we select DEBUG_KERNEL from EXPERT then 
you will avoid having to expand || EXPERT conditions into every 
default-enabled debug facility ...

My suggested solution will be a lot easier to maintain as well as 
under your scheme, because with your scheme we'd have to:

  - add || EXPERT every time a debug facility is enabled by default

  - remove || EXPERT every time a debug facility is switched to 
    off-by-default

If EXPERT selects DEBUG_KERNEL then we always get the right behavior, 
without polluting debug Kconfig's with EXPERT logic ...


Thanks,

	Ingo
