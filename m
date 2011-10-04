Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1JDHk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:40:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53106 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1JDHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:40:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Date: Tue, 4 Oct 2011 09:40:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, stable@kernel.org
References: <20111004112623.aa04e959d29cb19af8053739@canb.auug.org.au>
In-Reply-To: <20111004112623.aa04e959d29cb19af8053739@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110040940.12876.arnd@arndb.de>
X-Provags-ID: V02:K0:lOlxhU5bWJn1MroiItX8JLuGrvQz7/GZjPY5yYEimyG
 3Y7PB8nYqyu3DoYF2i58haS42r3LCTu9ytvt73Ib2yPNrYtiEZ
 Mi4gsf4ML4mXlJnoCKXmGnYE+T7aedZKgMPdbC2XlpeQFSrNCr
 7kUsRaNDYNtxG23y4R6XHgimACeBLvidOt7gVNPHtpm4lM6M1l
 Zz5jNkMN5VZzZDatnmybuuT9rLly3UAPXc/6DpuahJAbDQf3Fb
 Pt+6SiomX2ebBHIE4ZkL9PL0UoheaEoRu5DRkYKoB5KuEri3r5
 buv/NrtSvpNB4zRfjYWUNiOCg0LbHfx1qetmZNvrYUAEk5at3T
 KuVVtRQKFa9Y/ykc22Us=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011, Stephen Rothwell wrote:
> After merging the arm-soc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "clk_enable" [drivers/misc/atmel_pwm.ko] undefined!
> ERROR: "clk_disable" [drivers/misc/atmel_pwm.ko] undefined!
> ERROR: "clk_put" [drivers/misc/atmel_pwm.ko] undefined!
> ERROR: "clk_get_rate" [drivers/misc/atmel_pwm.ko] undefined!
> ERROR: "clk_get" [drivers/misc/atmel_pwm.ko] undefined!
> 
> Caused by commit 9dccc010c816 ("ARM: at91: remove dependency for Atmel
> PWM driver selector in Kconfig").
> 
> I have used the arm-soc tree from next-20110930 for today.

Ah, thanks for tracking this down. I actually noticed the same
problem on an ARM build but did not realize it was from one of
the patches I had jut put in there myself.

I'm really glad I didn't send this to Linus cc:stable yet then.
Nicolas, in my randconfig branch, I've fixed this by adding

	depends on HAVE_CLK

which I think is the right solution. I'll replace your patch
with one that does this if you don't mind.

I'd also remove the stable tag for this patch, because it can
have unintended side-effects on other architectures.

	Arnd
