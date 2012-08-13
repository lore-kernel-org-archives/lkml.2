Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2HMU7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:59:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45310 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2HMU7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:59:42 -0400
Message-ID: <1344891576.16792.5.camel@maxim-laptop>
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: wwang <wei_wang@realsil.com.cn>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "bp@alien8.de" <bp@alien8.de>
Date: Mon, 13 Aug 2012 23:59:36 +0300
In-Reply-To: <201208011431.02050.arnd@arndb.de>
References: <1343720536-22077-1-git-send-email-wei_wang@realsil.com.cn>
	 <201207311123.25862.arnd@arndb.de> <5018CA65.1080906@realsil.com.cn>
	 <201208011431.02050.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 14:31 +0000, Arnd Bergmann wrote: 
> On Wednesday 01 August 2012, wwang wrote:
> > 于 2012年07月31日 19:23, Arnd Bergmann 写道:
> > >
> > > You posted the sdmmc host driver and the pci card reader driver.
> > > I assume that the USB card reader and the memstick host
> > > will also get posted at some point. Do you have a timeframe
> > > for those?
> > 
> > I will submit my memstick host driver around two months later, and
> > submit USB part at the end of this year.
> 
> ok.
> 
> > > The hardware seems to also support xd/smartmedia. Do you have
> > > plans to add those? I think we have some code in drivers/mfd
> > > that acts as an abstraction layer for these, given that the
> > > host has to do the wear leveling there too.
> > 
> > Yes, xD is still in our plan. But because the user population of xD/SM
> > is so small, we put the priority of writing xD host driver in a relevant
> > low level.
> > Maybe we will submit this driver in the next year.
> 
> Ok. When you get to that, I think you should use the code
> from drivers/mtd/nand/sm_common.c, but it's better to confirm
> that with the MTD maintainers first.
Just note that this file doesn't have much stuff as it turned out
that xD card readers and cards are just raw NAND.
Except that large xD cards, still use small block size, and somewhat
different IDs, thus I placed them in this file.

You just need to write a NAND driver exposing raw flash, and my sm_ftl
will take care of wear leveling and everything else.


If any questions, bug-reports, just notes, I glad to hear about this.
Best regards,
Maxim Levitsky

