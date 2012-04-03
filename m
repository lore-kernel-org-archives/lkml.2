Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2DCUob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:44:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53482 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2DCUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120330103828.GC22981@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	<1331285959.4657.76.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	<1331520476.4657.79.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	<CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
	<Pine.LNX.4.64.1203161128120.13465@axis700.grange>
	<CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
	<Pine.LNX.4.64.1203161522570.13465@axis700.grange>
	<CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
	<20120330103828.GC22981@n2100.arm.linux.org.uk>
Date: Tue, 3 Apr 2012 22:44:29 +0200
Message-ID: <CACRpkdbjNqsWvv_0roFLGm_uzVFCOfeaek65=bxiUhU3XQXwKA@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:38 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> Actually, I think that's the key thing: the handshake lines should be
> the data involved in channel selection and nothing else - though as I've
> pointed out already, there's the complication for external MUXing between
> the DMA engine and the peripheral which makes that non-trivial.

I think you're onto something here, and it sounds it could be made
elegant to me.

As for muxed request signals, we would need to hook in some
cascading framework if we want it all generic.

On the Nomadik 8815 (which I now have up and running)
the system has two PL080 instances, each with 16 channels.
However the same request lines are *partly* routed to *both*
PL080 instances. This would be one of the things we could
solve with a line-oriented approach, say we have this set
of DMA lines, and then defined a group of lines per
DMAC instance, then by stating that this device has this
request line we can infer the suitable DMA slave engines
and select one with a free channel to run the transfer.

It does require some upfront code, but I'm sure it can be
made to work.

Yours,
Linus Walleij
