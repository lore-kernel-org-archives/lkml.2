Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab2C3Kke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:40:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab2C3Kk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:40:28 -0400
Date: Fri, 30 Mar 2012 12:40:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120330102910.GB22981@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203301236330.24548@axis700.grange>
References: <1331284918.4657.69.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
 <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
 <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
 <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
 <Pine.LNX.4.64.1203161522570.13465@axis700.grange>
 <20120330102910.GB22981@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:v6nBjbq+nhFkWGmCTTGGyqbOIeHC2vLidLRHuVCzZX3
 WIUn3qWp7ptWnZIOeTpG3SVBHp9CIvivmsT3rkh3JF9WGgmnKt
 8sYebTvARB2oU+9aswla2eJBC1hs2xLlnX4/BoPjk9vd3xu0X4
 DlwkBfnRVxFHtHrfjL5J9hwGuA2VygQcBHJsyVuHV7Bp++Zc7X
 dse7UN8eOYjQrYoicqpOU5tbhwwtKOxETzBKqequ5jRO0hQnE4
 FRCBT4zSsmtrA/PrBsWjRSflAWW67aSfnRtAbnGpgZPzM5o4ZW
 DbQB7/xcHLZFVzde4BzAfOp9HTLGHN4JN7GMGQXjE8IENeDc+X
 xnYgFq8o6MzxMMmPjAz8WvdR/G/oqs+TWHoGQzYwWraMNUJj40
 nazc5GPgzbjPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Russell King - ARM Linux wrote:

> On Fri, Mar 16, 2012 at 03:28:39PM +0100, Guennadi Liakhovetski wrote:
> > Yessss!!! Let's do that! :-D Now, you're proposing exactly the same, as 
> > what I was proposing! :-) Now you just have to remove the filter function 
> > parameter from dma_request_channel() - it is anyway the same for all and 
> > implemented in the dmaengine core - and you get
> > 
> > dma_request_channel(mask, slave_desc)
> > 
> > which is exactly what I was proposing! :-)
> 
> Bollocks it is.  You're wanting to use the peripheral address, width
> and burst size to try to determine what channel to use.  That's a
> totally crackpot idea, and as I've already said several times it won't
> work in many real life cases we have already.

I'm afraid I'm just somehow failing to explain my thoughts to you, 
Russell. I don't think I ever said about using addresses, widths etc. They 
are not even used _now_ by the shdma.c driver. Why should I propose that 
then?

What I was proposing is to use some kind of an opaque slave ID for that. 
Which is, I think, pretty much the same as using a device pointer and DMA 
direction.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
