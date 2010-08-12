Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab0HLWcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:32:11 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52078 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004Ab0HLWcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ieRN0i7dxRSLxQQFkvUXJC4zapvRPOzj538G+sbfTZkpY1YBk/CgL2OxaRVIKJ5/FR
         2Y8JLgkVCH98VRLajljFfiIM8dgYDzK52WM0oZrz0ZGcalODw5kXk3WUmbmPqkr7uq8j
         eNI41UpVa0bp4QpZeo2DnucZ4mE/rEJrJPWog=
MIME-Version: 1.0
In-Reply-To: <20100812201601.GC27749@pengutronix.de>
References: <20100812150030.GB27749@pengutronix.de>
	<AANLkTikSExz3ELLEZ90LgitTsxwkE1dxu1BM1VhfCOmy@mail.gmail.com>
	<20100812201601.GC27749@pengutronix.de>
Date: Fri, 13 Aug 2010 00:32:08 +0200
Message-ID: <AANLkTikPs_03fX77FHAMuuq2kBtr6wrekrgExAp+ki2V@mail.gmail.com>
Subject: Re: dmaengine questions
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/12 Sascha Hauer <s.hauer@pengutronix.de>:
> [Dan]
>> Hopefully dma_chan->private can eventually be phased out in favor of
>> Linus' dma_slave_config scheme [1].
>
> This looks promising. Two things are missing here for the SDMA engine.
> First is the DMA request line which is probably needed for other dma
> engines aswell, so this could be added to dma_slave_config.

Do you really need to configure this at runtime?
The idea is to pass in stuff that is changed dynamically wheras
things that are fixed are passed in from platform data.

In the PL180 there was multiplexing functions for the lines even
(so one line was shared between different devices) in that case
I implemented platform-specific callbacks in the platform data
to request the lines.

> The other
> one is really specific to the SDMA engine, it's the following enum. The
> SDMA engine is a programmable controller in the i.MX and each peripheral
> has its own copy function in this controller. This enum is used to
> determine their start addresses.

Can't you pass in the actual address in src_address for RX and
dst_address for TX?

The idea here is that the driver know the physical address where
the bitpipe is supposed to end up, and the DMAengine does not.
If it was always the same address we could pass that also through
platform data but experience shows that some devices use different
addresses for different kinds of configurations, that's why it's there.

Maybe I'm just not getting it...

Yours,
Linus Walleij
