Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2CVHio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:38:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40630 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2CVHin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:38:43 -0400
Date: Thu, 22 Mar 2012 09:37:50 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Message-ID: <20120322073750.GA637@mwesterb-mobl.ger.corp.intel.com>
References: <4F683B36.8090101@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
 <20120321193231.GA3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48AB1@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020696D48AB1@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 07:47:52PM -0500, H Hartley Sweeten wrote:

> I think you misunderstood my comment above.
> 
> With this patch applied I get the "unknown interrupt!" storm. These messages
> keep getting spewed until I power off the board.

Ah, right you are. Sorry.

With my Sim.One board, I don't see any interrupt storms at all and I also have
mmc_spi with DMA enabled.

> Without this patch I get the "got interrupt while active list is empty" messages
> but only occasionally. Other than the messages the mmc_spi driver seems to
> be working ok with dma.
> 
> I hacked in a dump of the DMA Global Interrupt register when I get the
> "got interrupt while active list is empty" messages and get this:
> 
> dma dma1chan1: got interrupt while active list is empty (00000000)

In addition to these messages my board hangs almost every boot.

> So, according to the DMAGlInt register, there are no channels with an
> active interrupt.
> 
> Are we missing a write to the INTERRUPT registers somewhere to clear the
> current interrupt?

In the current code we only enable DONE interrupt and we always clear that at
the beginning of the ISR.

The VIC code was changed in 3.3. Its behaviour is different now as it tries to
handle as many IRQs as possible in one go whereas before it only handled one
IRQ at a time. Could it be that the VIC in ep93xx doesn't cope with that?
