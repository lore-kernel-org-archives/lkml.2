Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0CYWhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:37:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:53180 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752159Ab0CYWhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:37:18 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19Y1egsKw9YgXYb63OJ87/re5KuMfDC2t9e/DeCx/
	LoghIQvVhWEYOX
Date: Thu, 25 Mar 2010 23:37:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status
In-Reply-To: <e9c3a7c21003251500r27077cci67b1f06727be97f1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1003252334190.4413@axis700.grange>
References: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
  <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
 <e9c3a7c21003251500r27077cci67b1f06727be97f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Dan Williams wrote:

> On Thu, Mar 25, 2010 at 1:58 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Thu, 25 Mar 2010, Linus Walleij wrote:
> >
> >> Convert the device_is_tx_complete() operation on the
> >> DMA engine to a generic device_tx_status()operation which
> >> can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
> >> DMA_TX_PAUSED.
> >>
> [..]
> > General: you converted all drivers to the new .device_tx_status() API, but
> > since they don't implement "residue," you left it uninitialised
> > everywhere. Wouldn't it be better to set it to 0 or total length,
> > depending on the complete / not complete status?
> 
> Agree that it should not be uninitialized.  At the same time I do not
> want to require drivers that don't need it to go through the hassle of
> looking up a byte count, so perhaps all but the drivers that want this
> support can return a 'max byte count'??

Why not assign one of the two - 0 if the transfer is complete (DMA_SUCCESS 
status returned) or whatever max count otherwise? Except I do think this 
might confuse some users - seeing a residue larger than the total transfer 
length...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
