Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab0H0A0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:26:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:46965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0H0A0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:26:44 -0400
Date: Fri, 27 Aug 2010 09:26:17 +0900
To: khc@pm.waw.pl
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <m3iq2x2wgp.fsf@intrepid.localdomain>
References: <1282254713.22370.368.camel@pasglop>
	<20100826205344E.fujita.tomonori@lab.ntt.co.jp>
	<m3iq2x2wgp.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100827092453A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 27 Aug 2010 09:26:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 18:02:46 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> > Lots of drivers call dma_set_coherent_mask with 64bit mask and then
> > call it with 32bit mask if 64bit mask fails.
> 
> Which seems strange to me. If the driver asks for 64-bit mask and the
> system can only give it 32-bits, why return an error? Every 32-bit
> address is also 64-bit, with the most significant bits simply cleared.

As I wrote, the DMA API simply wasn't designed in that way (let
architectures to clip the mask), I guess.

If it was, dma_set_coherent_mask might return the actual mask.
