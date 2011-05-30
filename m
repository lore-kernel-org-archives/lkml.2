Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab1E3SlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:41:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1E3SlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:41:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Date: Mon, 30 May 2011 20:40:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <1306707270.2029.377.camel@i7.infradead.org> <201105301305.59166.arnd@arndb.de> <20110530102731.fa9fbc4a.rdunlap@xenotime.net>
In-Reply-To: <20110530102731.fa9fbc4a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105302040.55509.arnd@arndb.de>
X-Provags-ID: V02:K0:gUYKq+7tsA1vL5pyGc3eaDwNY4JbBo6Scp2BIFmQ65Y
 Tq4dT2zlJVrFPnqnHompUNFe+Si9K81gjmkZYvti3917kcANRA
 byd/dSUOPSRFzAV1SiYpzYWGOOzKXyQXilx8kjbAa66xp/f/ww
 5JIgfy5AflCejxclRf89NwftAV6IhXHawfVqUxOGVqdGpjrGA3
 xmsW+1vWWucKzplFBJSuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011 19:27:31 Randy Dunlap wrote:
> On Mon, 30 May 2011 13:05:58 +0200 Arnd Bergmann wrote:
> 
> Ingo recently wrote:
> | When it wont boot straight away (often it does) i use a 
> | Kconfig-needed set of minimal set of configs that enables the minimal 
> | hardware environment.
> 
> which I believe is the same method that is documented in
> Documentation/kbuild/kconfig.txt, subject "KCONFIG_ALLCONFIG": (partial text)
> 
> This enables you to create "miniature" config (miniconfig) or custom
> config files containing just the config symbols that you are interested
> in.  Then the kernel config system generates the full .config file,
> including symbols of your miniconfig file.
> 
> This 'KCONFIG_ALLCONFIG' file is a config file which contains
> (usually a subset of all) preset config symbols.  These variable
> settings are still subject to normal dependency checks.
> 

Very nice, I didn't know about it. Unfortunately, this seems to
suffer from the same problem as the generic "randconfig" -- it
ignores all "choice" statements and just uses the default:

Try for instance

KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make \
	O=obj-allmod/ allnoconfig ARCH=arm

This is supposed to set CONFIG_ARCH_OMAP, but it instead chooses
CONFIG_ARCH_VERSATILE, which means it's still useless for me.

	Arnd
