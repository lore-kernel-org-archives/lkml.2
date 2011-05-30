Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1E3VQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:16:11 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39229 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752784Ab1E3VQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:16:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=D2DbVVJvq5inw7oWoCiDfq/tRqtCjANMW7aZVN/SwjfMoEC76F0PstCaZpAQThKzO3HynJVdx2Wu4AveBAMknIPg6kaXMFXJEMM7LI/0zujzXVpS3XP9wjcyQXTp9dl/;
Date: Mon, 30 May 2011 14:16:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-Id: <20110530141606.a92f8b21.rdunlap@xenotime.net>
In-Reply-To: <BANLkTik36rFNDqAorY9gn2_mDPMmP_Y=iw@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<201105301305.59166.arnd@arndb.de>
	<20110530102731.fa9fbc4a.rdunlap@xenotime.net>
	<201105302040.55509.arnd@arndb.de>
	<BANLkTik36rFNDqAorY9gn2_mDPMmP_Y=iw@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 16:30:14 -0400 Arnaud Lacombe wrote:

> Hi,
> 
> On Mon, May 30, 2011 at 2:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 30 May 2011 19:27:31 Randy Dunlap wrote:
> >> On Mon, 30 May 2011 13:05:58 +0200 Arnd Bergmann wrote:
> >>
> >> Ingo recently wrote:
> >> | When it wont boot straight away (often it does) i use a
> >> | Kconfig-needed set of minimal set of configs that enables the minimal
> >> | hardware environment.
> >>
> >> which I believe is the same method that is documented in
> >> Documentation/kbuild/kconfig.txt, subject "KCONFIG_ALLCONFIG": (partial text)
> >>
> >> This enables you to create "miniature" config (miniconfig) or custom
> >> config files containing just the config symbols that you are interested
> >> in.  Then the kernel config system generates the full .config file,
> >> including symbols of your miniconfig file.
> >>
> >> This 'KCONFIG_ALLCONFIG' file is a config file which contains
> >> (usually a subset of all) preset config symbols.  These variable
> >> settings are still subject to normal dependency checks.
> >>
> >
> > Very nice, I didn't know about it. Unfortunately, this seems to
> > suffer from the same problem as the generic "randconfig" -- it
> > ignores all "choice" statements and just uses the default:
> >
> > Try for instance
> >
> > KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make \
> >        O=obj-allmod/ allnoconfig ARCH=arm
> >
> > This is supposed to set CONFIG_ARCH_OMAP, but it instead chooses
> > CONFIG_ARCH_VERSATILE, which means it's still useless for me.
> >
> hum...
> 
> % git describe
> v2.6.39
> 
> % KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make ARCH=arm
> allnoconfig
> scripts/kconfig/conf --allnoconfig Kconfig
> arch/arm/configs/omap2plus_defconfig:92:warning: symbol value 'm'
> invalid for BT_L2CAP
> arch/arm/configs/omap2plus_defconfig:93:warning: symbol value 'm'
> invalid for BT_SCO
> warning: (ARCH_STMP3XXX && ARCH_OMAP3 && ARCH_OMAP4) selects
> USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT)
> warning: (ARCH_OMAP4) selects PL310_ERRATA_588369 which has unmet
> direct dependencies (CACHE_L2X0)
> warning: (ARCH_OMAP4) selects PL310_ERRATA_727915 which has unmet
> direct dependencies (CACHE_L2X0)
> #
> # configuration written to .config
> #
> 
> % grep CONFIG_ARCH_OMAP .config
> CONFIG_ARCH_OMAP=y
> # CONFIG_ARCH_OMAP1 is not set
> CONFIG_ARCH_OMAP2PLUS=y
> # CONFIG_ARCH_OMAP2PLUS_TYPICAL is not set
> CONFIG_ARCH_OMAP2=y
> CONFIG_ARCH_OMAP3=y
> CONFIG_ARCH_OMAP4=y
> 
> did I missed something ?
> 
>  - Arnaud

Hey Arnaud,

Thanks.  I thought that I recalled some efforts being made in this area
and I checked my email folder but not git logs...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
