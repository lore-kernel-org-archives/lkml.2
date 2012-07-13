Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549Ab2GMQck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 12:32:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab2GMQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:32:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
Date: Fri, 13 Jul 2012 16:32:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: John Stultz <john.stultz@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <201207131240.03903.arnd@arndb.de> <20120713160233.GB5544@arm.com>
In-Reply-To: <20120713160233.GB5544@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207131632.31548.arnd@arndb.de>
X-Provags-ID: V02:K0:rW1j7OKJxXS9ve9PiRZyVOq6igWWdCTXMMGpGvL0yX0
 VJ79D0HNPsu05ut88Cdh/c511n/wXNutN2T1JnxI0wH8bXVZYR
 zfg4I/TgJCneXKwsOQ4MMtReGBjWD+SaMQkfD+7pXFDnVVTRfr
 DjOb9iXVyLzYuDagiOzgi88mkvX8izif2z/gE5Xk9vc2dyQlhk
 LWaEwkcBDlpWhxLGiZGAhUQzpSoCbY5wxsWuS67acL8uL46fRN
 8CgpUUL71aK3XEuV8YB2PJD63JLxcmvTx9id7a7J4DB/4bObGv
 vJSrLoP8yD4YYvLpxQj+kdZ+esSa+YGQvazIwl1sBksPVp2PxZ
 t6ba1kuDtpMdU9Z6pfNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2012, Catalin Marinas wrote:
> > Architectures that always have a working clock source would then just
> > not include the timex.h header and #define ACT_HZ HZ in common code.
> 
> Would something like below be enough?
> 
> Also, are there any implications if we boot with clocksource=jiffies?
> 
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -55,7 +55,11 @@
>                               + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
>  
>  /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
> +#ifdef CLOCK_TICK_RATE
>  #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
> +#else
> +#define ACTHZ (HZ << 8)
> +#endif
>  
>  /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
>  #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
> 

I think that's a very good step in the right direction, yes.

It does not let us get rid of the asm/timex.h file, but that's actually
a separate problem. It also wouldn't hurt to put the LATCH definition
in the same #ifdef.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd

