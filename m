Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2C3FoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:44:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33922 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2C3FoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203161522570.13465@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	<20120307162755.GB18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	<1331188201.4657.51.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	<1331204128.4657.54.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	<1331206459.4657.59.camel@vkoul-udesk3>
	<1331211513.4657.67.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	<1331284918.4657.69.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	<1331285959.4657.76.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	<1331520476.4657.79.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	<CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
	<Pine.LNX.4.64.1203161128120.13465@axis700.grange>
	<CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
	<Pine.LNX.4.64.1203161522570.13465@axis700.grange>
Date: Fri, 30 Mar 2012 07:44:09 +0200
Message-ID: <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 3:28 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 16 Mar 2012, Linus Walleij wrote:

>> Oh I was not thinking of relying on config to sort out channels.
>>
>> I was thinking of internalizing the dma_filter_fn and make it an
>> (optional, maybe?) part of dmaengine.
>
> Yessss!!! Let's do that! :-D Now, you're proposing exactly the same, as
> what I was proposing! :-)

No.

> Now you just have to remove the filter function
> parameter from dma_request_channel() - it is anyway the same for all and
> implemented in the dmaengine core - and you get
>
> dma_request_channel(mask, slave_desc)

What is the point of mask on slave channels?
I was more thinking introduce a new call:

dma_request_slave_channel(struct device *dev);

>From this the core looks up a suitable channel for that device.

However you're right (in some later mail) that we need to distinguish
between RX/TX channels at this point, so I can agree we need some
additional parameter, but that should be very abstract, not containing
any custom stuff or any void * or something like that.

If the device and direction is really all we need to distinguish a suitable
channel (which I imagine) the signature may very well be:

dma_request_slave_channel(struct device *dev, enum dma_transfer_direction dir);

But I'm not sure. (Keep beating me about it... but at this point
I think code speaks more than words.)

> which is exactly what I was proposing! :-)

Sorry, not at all AFAICT.

Yours,
Linus Walleij
