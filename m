Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab2CGQUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:20:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44015 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab2CGQUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:20:00 -0500
MIME-Version: 1.0
In-Reply-To: <20120307103112.GP17370@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
	<Pine.LNX.4.64.1203021341590.913@axis700.grange>
	<1331022623.24656.191.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203060935460.9300@axis700.grange>
	<1331035739.24656.201.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203061339330.9300@axis700.grange>
	<1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	<20120307093026.GM17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	<20120307103112.GP17370@n2100.arm.linux.org.uk>
Date: Wed, 7 Mar 2012 17:20:00 +0100
Message-ID: <CACRpkdZ+B1Joo7HgRnT4Eay0JEzkr105tgnON+J5YQLHsqm6jw@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 11:31 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> For example, the SA11x0 IrDA driver uses two virtual channels, one for
> receive and one for transmit.  The SA11x0 has a total of five DMA
> channels.  To waste two of them on IrDA when it's half-duplex is just
> silly.  Doing the whole 'request+free' thing is also silly because
> switching between tx and rx mode is timing-critical.

Oh. that's luxury! The ARM PB11MPcore has two physical DMA
channels.

If I lock one up for say continous UART RX I have only one left,
and that need to do everything else. So multiplexing the physical
engines it is a must.

Yours,
Linus Walleij
