Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1E3UaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:30:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64218 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab1E3UaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KORYp32B9qef6+w6y+wnwlzgOWGtEuTD6JdM1Pavw0Gn2NofORut2TZYAwhfYz4F3n
         rALyK8qK2L6cRD91MfCXPKdbmOW8U4v80Jisd+BqpKBSkAMGY4xBjarw43dWLk5E5EIe
         fEnDbF+uxO4zc2cvUXGyyvLKBGIeQN/zJ+bXE=
MIME-Version: 1.0
In-Reply-To: <201105302040.55509.arnd@arndb.de>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<201105301305.59166.arnd@arndb.de>
	<20110530102731.fa9fbc4a.rdunlap@xenotime.net>
	<201105302040.55509.arnd@arndb.de>
Date: Mon, 30 May 2011 16:30:14 -0400
Message-ID: <BANLkTik36rFNDqAorY9gn2_mDPMmP_Y=iw@mail.gmail.com>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 30, 2011 at 2:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 30 May 2011 19:27:31 Randy Dunlap wrote:
>> On Mon, 30 May 2011 13:05:58 +0200 Arnd Bergmann wrote:
>>
>> Ingo recently wrote:
>> | When it wont boot straight away (often it does) i use a
>> | Kconfig-needed set of minimal set of configs that enables the minimal
>> | hardware environment.
>>
>> which I believe is the same method that is documented in
>> Documentation/kbuild/kconfig.txt, subject "KCONFIG_ALLCONFIG": (partial text)
>>
>> This enables you to create "miniature" config (miniconfig) or custom
>> config files containing just the config symbols that you are interested
>> in.  Then the kernel config system generates the full .config file,
>> including symbols of your miniconfig file.
>>
>> This 'KCONFIG_ALLCONFIG' file is a config file which contains
>> (usually a subset of all) preset config symbols.  These variable
>> settings are still subject to normal dependency checks.
>>
>
> Very nice, I didn't know about it. Unfortunately, this seems to
> suffer from the same problem as the generic "randconfig" -- it
> ignores all "choice" statements and just uses the default:
>
> Try for instance
>
> KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make \
>        O=obj-allmod/ allnoconfig ARCH=arm
>
> This is supposed to set CONFIG_ARCH_OMAP, but it instead chooses
> CONFIG_ARCH_VERSATILE, which means it's still useless for me.
>
hum...

% git describe
v2.6.39

% KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make ARCH=arm
allnoconfig
scripts/kconfig/conf --allnoconfig Kconfig
arch/arm/configs/omap2plus_defconfig:92:warning: symbol value 'm'
invalid for BT_L2CAP
arch/arm/configs/omap2plus_defconfig:93:warning: symbol value 'm'
invalid for BT_SCO
warning: (ARCH_STMP3XXX && ARCH_OMAP3 && ARCH_OMAP4) selects
USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT)
warning: (ARCH_OMAP4) selects PL310_ERRATA_588369 which has unmet
direct dependencies (CACHE_L2X0)
warning: (ARCH_OMAP4) selects PL310_ERRATA_727915 which has unmet
direct dependencies (CACHE_L2X0)
#
# configuration written to .config
#

% grep CONFIG_ARCH_OMAP .config
CONFIG_ARCH_OMAP=y
# CONFIG_ARCH_OMAP1 is not set
CONFIG_ARCH_OMAP2PLUS=y
# CONFIG_ARCH_OMAP2PLUS_TYPICAL is not set
CONFIG_ARCH_OMAP2=y
CONFIG_ARCH_OMAP3=y
CONFIG_ARCH_OMAP4=y

did I missed something ?

 - Arnaud
