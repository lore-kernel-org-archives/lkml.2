Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0HZQCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:02:51 -0400
Received: from khc.piap.pl ([195.187.100.11]:40493 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab0HZQCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:02:50 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
References: <1282213882.22370.360.camel@pasglop>
	<20100819234835Y.fujita.tomonori@lab.ntt.co.jp>
	<1282254713.22370.368.camel@pasglop>
	<20100826205344E.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 26 Aug 2010 18:02:46 +0200
In-Reply-To: <20100826205344E.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Thu, 26 Aug 2010 20:55:09 +0900")
Message-ID: <m3iq2x2wgp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

> Lots of drivers call dma_set_coherent_mask with 64bit mask and then
> call it with 32bit mask if 64bit mask fails.

Which seems strange to me. If the driver asks for 64-bit mask and the
system can only give it 32-bits, why return an error? Every 32-bit
address is also 64-bit, with the most significant bits simply cleared.

It makes sense the other way around, if the device wants e.g. 24-bit
mask (ISA or something) but the OS doesn't have a memory pool smaller
than e.g. 4 GB then returning with error is ok.

Same with IXP4xx (and perhaps PXA) - the device wants 32 bits and it's
fine, even if the mask is set to 28 bits since the CPU can't let PCI
access more.

If the device wants to know if it should issue DACs or something like
that, sure - just check the current masks (effective).
-- 
Krzysztof Halasa
