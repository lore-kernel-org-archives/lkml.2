Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0HSVw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:52:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:39719 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0HSVwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:52:23 -0400
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100819234835Y.fujita.tomonori@lab.ntt.co.jp>
References: <20100813215413.GA21607@n2100.arm.linux.org.uk>
	 <20100814181306U.fujita.tomonori@lab.ntt.co.jp>
	 <1282213882.22370.360.camel@pasglop>
	 <20100819234835Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 07:51:52 +1000
Message-ID: <1282254713.22370.368.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 23:50 +0900, FUJITA Tomonori wrote:
> 
> You mean that you like to permit architectures to modify
> dev->coherent_dma_mask behind a device? If so, I'm against it because
> it means dev->coherent_dma_mask has two meanings. That's confusing.

No it's not. It has one and only one meaning which is the mask defining
where the coherent memory can come from for that device. Nobody cares if
the device can do more and has been "clipped" at set_coherent_dma_mask()
time by the bus. This is not useful information.

So I beleive the arch should hook the later and modify the mask as it
gets applied -once-.

> I don't plan to have the generic code to deal with multiple masks. I
> thought about simply moving max_direct_dma_addr in POWERPC's
> dev_archdata to a generic place (possibly, struct
> device_dma_parameters). I think that having the generic place for bus'
> dma mask would be better rather than architecture specific
> places. Adding a new API to set bus' dma mask would make sense too.

Well, max_direct_dma_addr used on powerpc is a bit nasty because it
doesn't necessarily represent a power of 2, so a mask is no good here
indeed.

> > Besides, in embedded-land, you never know how many busses are
> stacked
> > before you reach the device, ie, you'd end up having to AND quite a
> > few masks before getting there in some cases.
> >
> > Sounds better to establish that once, at set_coherent_dma_mask()
> time.
> 
> As long as dev->coherent_dma_mask represents the same thing on every
> architecture, permitting architectures to have the own
> dma_set_coherent_mask() is fine by me. I like to avoid it if possible
> though.

Ben.


