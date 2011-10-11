Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab1JKUWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:22:33 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:33327 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262Ab1JKUWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:22:32 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Oct 11 (gpio regulator)
Date: Tue, 11 Oct 2011 22:22:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au> <4E9499BB.6030607@xenotime.net>
In-Reply-To: <4E9499BB.6030607@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112222.24646.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Am Dienstag 11 Oktober 2011, 21:32:11 schrieb Randy Dunlap:
> On 10/11/11 02:11, Stephen Rothwell wrote:
> > Hi all,
> > 
> > The linux-next tree is now available from
> > git://github.com/sfrothwell/linux-next.git as a temporary measure while
> > the kernel.org servers are unavailable.
> > 
> > It may also turn up on git.kernel.org (depending on the mirroring).  The
> > patch set is still absent, however.
> > 
> > Changes since 20111007:
> > 
> > The gpio tree still has its build failure so I used the version from
> > next-20111005.
> 
> (maybe fixed there?)
> (i386 build)
> 
> drivers/regulator/gpio-regulator.c:121:3: error: invalid use of undefined
> type 'struct gpio' drivers/regulator/gpio-regulator.c:121:29: error:
> dereferencing pointer to incomplete type
> drivers/regulator/gpio-regulator.c:191:32: error: invalid application of
> 'sizeof' to incomplete type 'struct gpio'
> drivers/regulator/gpio-regulator.c:281:3: error: invalid use of undefined
> type 'struct gpio' drivers/regulator/gpio-regulator.c:281:20: error:
> dereferencing pointer to incomplete type
> 
> (GPIOLIB is not enabled.)
> Full randconfig file is attached.

thanks for catching this.

I would guess the Kconfig entry of the gpio-regulator needs a
		"depends on GENERIC_GPIO"
as it won't be able to function without gpiolib - correct?

Heiko
