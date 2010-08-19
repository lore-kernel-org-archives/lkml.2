Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0HSKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:31:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:43227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0HSKbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:31:50 -0400
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100814181306U.fujita.tomonori@lab.ntt.co.jp>
References: <20100811072532.GA21511@n2100.arm.linux.org.uk>
	 <20100813152224H.fujita.tomonori@lab.ntt.co.jp>
	 <20100813215413.GA21607@n2100.arm.linux.org.uk>
	 <20100814181306U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 20:31:22 +1000
Message-ID: <1282213882.22370.360.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-14 at 18:30 +0900, FUJITA Tomonori wrote:
> 
> A long solution would be having two dma_mask for a device and a
> bus. We also need something to represent a DMA-capable range instead
> of the dma mask.

I'd rather have the arch (aka the bus) be able to filter the mask,
better than having to deal with multiple masks in the generic code.
Besides, in embedded-land, you never know how many busses are stacked
before you reach the device, ie, you'd end up having to AND quite a few
masks before getting there in some cases.

Sounds better to establish that once, at set_coherent_dma_mask() time.

Cheers,
Ben.


