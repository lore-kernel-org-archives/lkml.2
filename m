Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966035Ab2DLVde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:33:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762860Ab2DLVdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:33:31 -0400
Date: Thu, 12 Apr 2012 23:33:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <CACRpkdbjNqsWvv_0roFLGm_uzVFCOfeaek65=bxiUhU3XQXwKA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1204122325580.15801@axis700.grange>
References: <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
 <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
 <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
 <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
 <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
 <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
 <Pine.LNX.4.64.1203161522570.13465@axis700.grange>
 <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
 <20120330103828.GC22981@n2100.arm.linux.org.uk>
 <CACRpkdbjNqsWvv_0roFLGm_uzVFCOfeaek65=bxiUhU3XQXwKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:SJ6L9C53VGUZ+Iz4OoUY1uSp+LhWjtJDHgALQ2yr5T8
 S6NjBry0OmTjn4PRvvool5Y8GH1a/KPXYWiXc5cUYKdjNDPEDl
 RvXz9FdmM7Z7AcaFFRaWJIYfqTV7APVLmSZoVpkdES/ggN+THv
 JRmqWfENn5BCT/MPQpcz3g2tRncmrbTLveLol30ejiLk34vG/N
 3rfl7QRsxx69gys5XGpyDQ/57yLd1sN8jTLfpZ1rimocYHVfRJ
 TkqF9XevzA+6w3eKEDhtw62QucwEUkHfMVu6sAaU8vntkNb/Qy
 nLI/SjNAjDnRW+Y17s3F6t7eIPcUcVZ3huFiTD9FD2jM0kN4hK
 mRizo0Sulnh1Al65SFp9O5tU7IP6AYi7uvhihFMiiamNWhngrb
 GGMlBL1NNJoXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Linus Walleij wrote:

> On Fri, Mar 30, 2012 at 12:38 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> 
> > Actually, I think that's the key thing: the handshake lines should be
> > the data involved in channel selection and nothing else - though as I've
> > pointed out already, there's the complication for external MUXing between
> > the DMA engine and the peripheral which makes that non-trivial.
> 
> I think you're onto something here, and it sounds it could be made
> elegant to me.

Now, how do we proceed from here? Do I understand it right, that Russell 
would like to implement his ideas? Any idea when this is likely to happen? 
If not too soon, maybe we could / should work out an intermediate 
solution? How about, for example: I resubmit my patch, but don't claim it 
for general use, rather keep it sh-own (even though the generic part will 
have no hardware-specific code in it). Then we can implement both sh 
driver on top of that. Of course, the dubious use of the struct 
dma_chan::private field will remain. But it is there now anyway, so, this 
will not introduce any new uses of .private or extend the existing one. 
And once we have a generic way to request specific DMA channels, we'll 
switch the shdma driver(s) to it too.

Thanks
Guennadi

> 
> As for muxed request signals, we would need to hook in some
> cascading framework if we want it all generic.
> 
> On the Nomadik 8815 (which I now have up and running)
> the system has two PL080 instances, each with 16 channels.
> However the same request lines are *partly* routed to *both*
> PL080 instances. This would be one of the things we could
> solve with a line-oriented approach, say we have this set
> of DMA lines, and then defined a group of lines per
> DMAC instance, then by stating that this device has this
> request line we can infer the suitable DMA slave engines
> and select one with a free channel to run the transfer.
> 
> It does require some upfront code, but I'm sure it can be
> made to work.
> 
> Yours,
> Linus Walleij
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
