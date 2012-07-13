Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2GMMk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:40:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135Ab2GMMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:40:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
Date: Fri, 13 Jul 2012 12:40:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <62038bf130381e2b55cedec5f3c44760@localhost> <4FFF0BE9.2010307@linaro.org>
In-Reply-To: <4FFF0BE9.2010307@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207131240.03903.arnd@arndb.de>
X-Provags-ID: V02:K0:WrhO3mfc2Z+v3BXbkuD8nOFLpE2Cs1j2AkfDnUt/jkI
 8h4xFYPenjV2yee8vAdZQyn1VInZj5Th3G+vjrbo4dforfkoyW
 CHTGucYDNpQNlYrJwWIUejSAnfbMWiP8/g1K6bLCjBnvzqvRHv
 J09IcMnAUJnFeQzMMzJc4pkmtSlmucj5AK7/hO2JvWTTAbqYxh
 PiBMm5TI5sjXBcdgYL3JCB10OvsgLcrA76M+GTTfg9iA2Q32oc
 rZIi7vkYBYAYAy/uM49ltaxeQX3p5evMZSRPSsXgXVPxr4Y8On
 cODdN7Uii6JTcGO6971RuEbCYbXtxvC4z+g4Aa2wrjgFuVPX6P
 ZBJLOFIQRNYHIHkd76E0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2012, John Stultz wrote:
> 
> On 07/12/2012 10:31 AM, Marc Zyngier wrote:
> > On Thu, 12 Jul 2012 09:57:33 -0700, John Stultz <john.stultz@linaro.org>
> > wrote:
> >
> >> So following ia64's method is probably better then copying the 8253's
> >> rate if you're not concerned about tick-granularity error.
> > The 8253 is completely meaningless in our case (though I'm sure someone
> > could try and bold one on the side of an Aarch64 CPU...), so going the ia64
> > way is probably best (erm... this last bit doesn't sound quite right,
> > doesn't it?).
> 
> Sorry, the "copying the 8253's" bit didn't come out sarcastic enough.  :)
> 
> The best solution would be to include the actual tick-granularity, but 
> given its not really an architecture constant (which CLOCK_TICK_RATE 
> assumes), that probably wouldn't be appropriate.

Hmm, in the quest to eliminate CLOCK_TICK_RATE entirely, could we
make a Kconfig symbol that is selected for all architectures that
(may) rely on a periodic timer tick and require this to be set?

Architectures that always have a working clock source would then just
not include the timex.h header and #define ACT_HZ HZ in common code.

	Arnd
