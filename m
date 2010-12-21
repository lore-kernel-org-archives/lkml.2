Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0LUXrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:47:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44348 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0LUXrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:47:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Prevent users from disabling tickless
Date: Wed, 22 Dec 2010 00:46:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <20101221233942.GL1263@parisc-linux.org>
In-Reply-To: <20101221233942.GL1263@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012220046.23759.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 22, 2010, Matthew Wilcox wrote:
> 
> Disabling NO_HZ has a serious negative effect on performance -- an extra
> 70us per I/O.  Prevent users from deselecting it.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

OTOH, it causes some systems to not work at all still.  Sadly.

Thanks,
Rafael


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
> 

