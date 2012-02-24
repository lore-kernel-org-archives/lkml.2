Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2BXQhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:37:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55819 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2BXQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:37:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in cond_syscall
Date: Fri, 24 Feb 2012 16:37:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F47981F.4020305@imgtec.com> <201202241424.07319.arnd@arndb.de> <201202241119.44480.vapier@gentoo.org>
In-Reply-To: <201202241119.44480.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241637.30284.arnd@arndb.de>
X-Provags-ID: V02:K0:lyk0Dtf9rM7k0djyPGKqcxfIFFOD6r2XLn85OWWV7sS
 VDW7U7GfatREM5vZ29mKxDE16IYpFsDjOC7siPa0jZPQfKvbpB
 fAYCe2FLMNRVIEOCQCmvl6edfa6vvuh9518GqQp6nvHR88GLJz
 Ryuk53bIEpYnFySRLbR6mtM8SWB3X39PTaLx6227WWNPVCG1m/
 RC2oKn00P2UoP1pms+3O0+It/yjcwGmUUm+n7EODBEZmRElEhY
 UhF+H1HMU5WORYmJ5vX6KrATBG1vybsE9b6WRIaiD3+8EltZq9
 H41//+p/OEpYeGsXrn+TID5hWjiAACFFdji+BqDBpOtk7YyFDu
 NYl3ixKyUjC+sMBk/yeE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 February 2012, Mike Frysinger wrote:
> > Our trend is to move away from arch specific Kconfig symbols and
> > __ARCH_HAS_* macros towards just defining whatever you need in the
> > architecture as an override for the generic definition.
> 
> i don't see how __ARCH_HAS_xxx would help here.  the symbol prefix is a string, 
> not a bool value.  it's also already used by linux/export.h, asm-
> generic/vmlinux.lds.h, and module code in scripts/.

I gave __ARCH_HAS_xxx as an example because a lot of other places use that
to abstract architecture specific features, even if that wouldn't apply
here.

> > Just provide your own unistd.h that does
> 
> the point of asm-generic is so that arches don't have to keep copying & 
> pasting things that they really don't care about.  James' proposed patch looks 
> good to me.  it might be nice to go even further and add logic to a core 
> header so that CONFIG_SYMBOL_PREFIX is always defined ...

You are right. I did not realize that CONFIG_SYMBOL_PREFIX is an existing
symbol rather one that James defined for this purpose.

We actually have MODULE_SYMBOL_PREFIX providing the correct string
under a name that is not appropriate here. We can probably stick with
Jason's patch for now and add a more sophisticated logic if another
user of CONFIG_SYMBOL_PREFIX comes up.

So for Jason's patch:

Acked-by: Arnd Bergmann <arnd@arndb.de>

We could put that into the kernel now, but it's probably sufficient if
Jason keeps the patch with his others and submits it at the same time
when we get there.

	Arnd
