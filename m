Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0FNNpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:45:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:35716 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751835Ab0FNNpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:45:04 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+Y/wo4VcyYV3QO9Ed80Plp8ACI9mXCQHdT5vihKX
	LS3faIwhvWD1Kx
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Date: Mon, 14 Jun 2010 15:44:58 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.4; i686; ; )
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201005271944.09541.toralf.foerster@gmx.de> <201006141149.24647.toralf.foerster@gmx.de> <20100614130039.GA4618@kryptos.osrc.amd.com>
In-Reply-To: <20100614130039.GA4618@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201006141544.59500.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Borislav Petkov wrote at 15:00:39

> Linus' tree doesn't contain the fix yet - rather it is in -tip:
> http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6
> 
> You can easily cherry-pick it from there and retest.
Issue solved works with that patch.

FWIW : This command sequence produced a linux executable which crashed too:

$> ~/devel/linux-2.6 $ patch -p1 < ../linux-2.6-
tip.git-055c47272b8f5679d08ccc57efea3cb4aaeb5fc6.patch patching file 
arch/um/include/asm/arch_hweight.h

$> ~/devel/linux-2.6 $ make ARCH=um CC="ccache gcc"
make[1]: `arch/um/sys-i386/user-offsets.s' is up to date.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  LINK linux
$> start_uml.sh
...

But after I compiled it w/o ccache

$> ~/devel/linux-2.6 $ make ARCH=um

linux executable works (!?!)

Anyway thx for the fix
:-)

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

