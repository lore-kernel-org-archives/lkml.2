Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1ABI56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:57:58 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51022 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751022Ab1ABI54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 03:57:56 -0500
Date: Sun, 2 Jan 2011 09:57:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent users from disabling tickless
Message-ID: <20110102085755.GA32469@atrey.karlin.mff.cuni.cz>
References: <20101221233942.GL1263@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221233942.GL1263@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Disabling NO_HZ has a serious negative effect on performance -- an extra
> 70us per I/O.  Prevent users from deselecting it.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

System with fixed HZ is really simpler etc... and 70us per i/o does
not sound that bad.

Anyway, should not i/o overhead just be fixed?
								Pavel

> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index f06a8a3..55b9a04 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -5,13 +5,9 @@ config TICK_ONESHOT
>  	bool
>  
>  config NO_HZ
> -	bool "Tickless System (Dynamic Ticks)"
> +	def_bool y
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
>  	select TICK_ONESHOT
> -	help
> -	  This option enables a tickless system: timer interrupts will
> -	  only trigger on an as-needed basis both when the system is
> -	  busy and when the system is idle.
>  
>  config HIGH_RES_TIMERS
>  	bool "High Resolution Timer Support"
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
