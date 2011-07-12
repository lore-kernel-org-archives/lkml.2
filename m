Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1GLRNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:13:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:43803 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1GLRNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:13:44 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1310490820!28403153!14
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>,
        =?iso-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.nolf.barco@gmail.com" <thierry.nolf.barco@gmail.com>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Date: Tue, 12 Jul 2011 12:13:08 -0500
Subject: RE: [PATCH] new helper to define common struct resource constructs
Thread-Topic: [PATCH] new helper to define common struct resource constructs
Thread-Index: AcxAl9ZO148rhTNRQ/WfjqzOqPzxLgAGzyXg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F383D6DAD4@AUSP01VMBX24.collaborationhost.net>
References: <14C4E31473AF7E4B98176CB73615181C19FBD3@039-SN1MPN1-006.039d.mgd.msft.net>
	<201107072304.05626.arnd@arndb.de>
	<E1QgHeh-0004k8-2m@octopus.hi.pengutronix.de>
 <201107121529.17611.arnd@arndb.de>
In-Reply-To: <201107121529.17611.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 12, 2011 6:29 AM, Arnd Bergmann wrote:
> On Monday 11 July 2011, Uwe Kleine-König wrote:
>> resource definitions that just define start, end and flags = IORESOURCE_MEM
>> or IORESOURCE_IRQ (with start=end) are quite common. So introduce a shortcut
>> for them. Also make available a macro to specify named resources of both
>> types which are less common.
>> 
>> Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> What do others think, is this worthwhile?

Assuming I found the correct patch in the archives, +1 from me.  Not sure what
the correct sign-off should be, possibly:

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

> Should we also define macros for IORESOURCE_IO and IORESOURCE_DMA?

As a gross check, on linux-next I see:

$ git grep IORESOURCE_MEM | wc -l
3989
$ git grep IORESOURCE_IRQ | wc -l
2309
$ git grep IORESOURCE_IO | wc -l
687
$ git grep IORESOURCE_DMA | wc -l
521

The *_MEM and *_IRQ macros are going to have the largest impact on reducing
the lines of code.  But, for completeness it might be nice to have the *_IO
and *_DMA ones also.

If this patch is accepted there are a couple private macros in various places
that should probably be replaced or updated.

For instance in mach-nomadik/board-nhk8815.c and mach-nomadik/cpu-8815.c there
are these:

#define __MEM_4K_RESOURCE(x) \
	.res = {.start = (x), .end = (x) + SZ_4K - 1, .flags = IORESOURCE_MEM}

And plat-omap/i2c.c has this:

#define I2C_RESOURCE_BUILDER(base, irq)			\
	{						\
		.start	= (base),			\
		.end	= (base) + OMAP_I2C_SIZE,	\
		.flags	= IORESOURCE_MEM,		\
	},						\
	{						\
		.start	= (irq),			\
		.flags	= IORESOURCE_IRQ,		\
	},

I seem to recall seeing others but can't remember exactly where.

Regards,
Hartley