Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2CGJzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:55:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64876 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2CGJzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:55:16 -0500
MIME-Version: 1.0
In-Reply-To: <20120307093026.GM17370@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
	<Pine.LNX.4.64.1203021341590.913@axis700.grange>
	<1331022623.24656.191.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203060935460.9300@axis700.grange>
	<1331035739.24656.201.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203061339330.9300@axis700.grange>
	<1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	<20120307093026.GM17370@n2100.arm.linux.org.uk>
Date: Wed, 7 Mar 2012 10:55:16 +0100
Message-ID: <CACRpkdZ-dG9pSDdhUB0Vo+v4qt3cX0SvWBECj0P2w1nvnxYBew@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 10:30 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> The code required to support slave device transfers is very much the same
> for each driver (that's partly because I'm writing my drivers in the same
> way.)  Essentially, slave channels aren't physical channels themselves,
> but virtual channels which get assigned to physical channels at some point.

Actually in the COH901318 driver each device has a dedicated physical
channel. It looks like some hardware engineer took the PL080 VHDL
code and just copy/pasted as many instances of the channel engine as
was needed to provide a unique channel for each device.

I've been scratching my head over that when I've thought about
merging the two drivers, because the register set and LLI is actually
very similar.

> I would really like to see some common infrastructure for handling these
> virtual channels so I don't have to write yet another version of that code,
> and that's something I'll be working on.

Please go ahead with this! We have the same problem in the
DMA40 driver basically, but in this thing the hardware actually takes
care of the virtual-over-physical channel arbitration if you want to,
which makes the "virtual" channels have physical registers and
confusing things a bit.

(However in the DMA40 case it may be some point in actually trying to
just use the physical channels in that driver and have the dmaengine core
arbitrate these under some circumstances, we already have some
special flags to lock down certain physical channels.)

Yours,
Linus Walleij
