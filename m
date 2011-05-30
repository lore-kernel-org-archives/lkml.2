Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab1E3R1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:27:36 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57586 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753383Ab1E3R1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:27:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DH+/MlPmrs8FM1gmp1IgmfuMN7YHD4ulsin7cBmelOOsd8vrh9gUIFRSzMgNDxeQkII91mKIXC7J/Xc6knBGr6RDPUWHOVcNkY2PZa9ljOIyco0Qsw2qrM3WIcorH7Cl;
Date: Mon, 30 May 2011 10:27:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-Id: <20110530102731.fa9fbc4a.rdunlap@xenotime.net>
In-Reply-To: <201105301305.59166.arnd@arndb.de>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<201105301305.59166.arnd@arndb.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 13:05:58 +0200 Arnd Bergmann wrote:

> On Monday 30 May 2011, David Woodhouse wrote:
> > And as I said, it's still an incomplete solution if you actually want a
> > 'filtered randconfig' to do anything *useful*. You'd be much better off
> > implementing a real filtered randconfig that allows you to give a list
> > of hard-coded options, rather than relying on a dirty hack that only
> > actually sets one option of the many that you might need to
> > 'hard-code' if you actually wanted a useful build.
> 
> I'm actually looking for a way to do filtered randconfig (and
> all{yes,mod,no}config) for ARM, so hopefully we can come up with
> something useful.
> 
> Our problem today is that we have not just two but dozens of
> incompatible platforms, and with randconfig every 'choice'
> statements still just gets its default, which makes randconfig
> builds fairly useless.
> 
> What I'd like to see is one or both of these two behaviors:
> 
> * Take a defconfig file (with the new format that only sets
>   non-default options), and keep everything in there but
>   apply the rand/no/yes/mod-config to all other symbols.

Ingo recently wrote:
| When it wont boot straight away (often it does) i use a 
| Kconfig-needed set of minimal set of configs that enables the minimal 
| hardware environment.

which I believe is the same method that is documented in
Documentation/kbuild/kconfig.txt, subject "KCONFIG_ALLCONFIG": (partial text)

This enables you to create "miniature" config (miniconfig) or custom
config files containing just the config symbols that you are interested
in.  Then the kernel config system generates the full .config file,
including symbols of your miniconfig file.

This 'KCONFIG_ALLCONFIG' file is a config file which contains
(usually a subset of all) preset config symbols.  These variable
settings are still subject to normal dependency checks.



> * Randomize all settings, including choice statements.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
