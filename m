Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GMVqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:46:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1GMVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:46:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] new helper to define common struct resource constructs
Date: Wed, 13 Jul 2011 23:42:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        thierry.nolf.barco@gmail.com, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org,
        " Uwe =?iso-8859-1?q?Kleine-K=F6nig?= " 
	<u.kleine-koenig@pengutronix.de>,
        Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
References: <14C4E31473AF7E4B98176CB73615181C19FBD3@039-SN1MPN1-006.039d.mgd.msft.net> <201107121529.17611.arnd@arndb.de> <20110713141849.b8cbf675.akpm@linux-foundation.org>
In-Reply-To: <20110713141849.b8cbf675.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107132342.18648.arnd@arndb.de>
X-Provags-ID: V02:K0:tB+TAeUbOmWj40fn9CklPEdFiOr6AuiMD0Ejf2JnYkh
 3kkMA/OyY8iCZb+SBc1/22Im3fQ/omCMRzdtWwVusZnLYls/du
 3+z1gn4Qgf6lvil/vwUXCjL7Qf1wIsFc5J8CQfAhLn8IxpByPN
 ZVDrY4X50bTSqwL1IOMnqsqzodz2KPRLHWUCmS0ndBPk2+winy
 WJvIAiFqFoRljxfXffG7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 July 2011 23:18:49 Andrew Morton wrote:
> > On Monday 11 July 2011, Uwe Kleine-K__nig wrote:
> > > resource definitions that just define start, end and flags = IORESOURCE_MEM
> > > or IORESOURCE_IRQ (with start=end) are quite common. So introduce a shortcut
> > > for them. Also make available a macro to specify named resources of both
> > > types which are less common.
> > > 
> > > Signed-off-by: Uwe Kleine-K____nig <u.kleine-koenig@pengutronix.de>
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > What do others think, is this worthwhile?
> > Should we also define macros for IORESOURCE_IO and IORESOURCE_DMA?
> > 
> 
> It would help if we could see some usage examples (ie: sample
> conversions), to get a better idea of the value of this.

Uwe posted a patch '[PATCH] ARM: mxc: use new helpers to define
common struct resource entries' that converts one ARM platform to use
it, with reasonable outcome:

26 files changed, 72 insertions(+), 308 deletions(-)

This platform has 72 definitions of static resources, in total there
are well over 2000 such defintions in ARM alone, and the number is
growing. Some platforms have started creating their own macros for
this purpose, which is why I suggested doing it globally (or alternatively
removing the macros from these platforms if we conclude that they
are harmful).

> Also, DEFINE_RES_NAMED() is going to need a bunch of argument
> parentheses to make it bulletproof.

Right.

	Arnd
