Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1E3UB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:01:27 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38216 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757521Ab1E3UB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:01:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r7MNwVWKWda39d5Bj/k6ludh4Etnc7EX2EAn1A/g9OsKEscq85H9CoHEP6ce/YdBsQ1vIm+29OwIArRRzVUoUc0ANY07ZnTh8wZRLFjjwsrB5i+fLuqeic8qm6/fkACi;
Date: Mon, 30 May 2011 13:01:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnd Bergmann <arnd@arndb.de>, linux-kbuild@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-Id: <20110530130123.58153ec5.rdunlap@xenotime.net>
In-Reply-To: <201105302040.55509.arnd@arndb.de>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<201105301305.59166.arnd@arndb.de>
	<20110530102731.fa9fbc4a.rdunlap@xenotime.net>
	<201105302040.55509.arnd@arndb.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 20:40:55 +0200 Arnd Bergmann wrote:

> On Monday 30 May 2011 19:27:31 Randy Dunlap wrote:
> > On Mon, 30 May 2011 13:05:58 +0200 Arnd Bergmann wrote:
> > 
> > Ingo recently wrote:
> > | When it wont boot straight away (often it does) i use a 
> > | Kconfig-needed set of minimal set of configs that enables the minimal 
> > | hardware environment.
> > 
> > which I believe is the same method that is documented in
> > Documentation/kbuild/kconfig.txt, subject "KCONFIG_ALLCONFIG": (partial text)
> > 
> > This enables you to create "miniature" config (miniconfig) or custom
> > config files containing just the config symbols that you are interested
> > in.  Then the kernel config system generates the full .config file,
> > including symbols of your miniconfig file.
> > 
> > This 'KCONFIG_ALLCONFIG' file is a config file which contains
> > (usually a subset of all) preset config symbols.  These variable
> > settings are still subject to normal dependency checks.
> > 
> 
> Very nice, I didn't know about it. Unfortunately, this seems to
> suffer from the same problem as the generic "randconfig" -- it
> ignores all "choice" statements and just uses the default:
> 
> Try for instance
> 
> KCONFIG_ALLCONFIG=arch/arm/configs/omap2plus_defconfig make \
> 	O=obj-allmod/ allnoconfig ARCH=arm
> 
> This is supposed to set CONFIG_ARCH_OMAP, but it instead chooses
> CONFIG_ARCH_VERSATILE, which means it's still useless for me.

baa humbug.

dear linux-kbuild, can "choice" choices be made random during
"make randconfig", please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
