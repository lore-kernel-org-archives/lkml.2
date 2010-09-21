Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0IUWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:09:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37582 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0IUWJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wq4Zo6cLotaxN1s9C09HOtxnx2al2dsj4yjnR8MLt5964E7604sDgc6B67yHNZDnFv
         E5+VrBx4OpwQneoFzWkmxBHVZ2jSraZKzN8qwr4gsCtH0csHNohGk7KWMqPtaOLpshv+
         P3saARLkmvboRw70bZPdJ4g/1F/3iD9MItV3w=
MIME-Version: 1.0
In-Reply-To: <2C3F2C02-35B6-46AF-82DA-44ACCBFB8362@digitaldans.com>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
 <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
 <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
 <20100921163456.7e2c9b32@udp111988uds.am.freescale.net> <AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
 <20100921164944.164ed0af@udp111988uds.am.freescale.net> <2C3F2C02-35B6-46AF-82DA-44ACCBFB8362@digitaldans.com>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Tue, 21 Sep 2010 17:08:54 -0500
Message-ID: <AANLkTinKbBBbC1gmPewhn1f3MW-1MbARtiQZNX4w7Mi+@mail.gmail.com>
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
To: Dan Malek <ppc6dev@digitaldans.com>
Cc: Scott Wood <scottwood@freescale.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 5:05 PM, Dan Malek <ppc6dev@digitaldans.com> wrote:

> The DMA descriptors are accessed using DMA by the
> controller itself.

Yes and no.  Technically, it is DMA, but it's not something that
SWIOTLB could ever know about.  We just pass the physical address to
the DMA controller, and it does a memory read to obtain the data.
That's not the kind of DMA that SWIOTLB would deal with, I think.

> The APIs need to ensure proper coherency
> between the CPU and the DMA controller for the
> descriptor access.  The underlying implementation of the
> API will depend upon the hardware capabilities that
> ensure this coherency.

I think that's already covered.  The dma_set_mask() call is supposed
to only affect the dma_map_single() calls that dmaengine makes, as
Scott pointed out.

My question is, should dmaengine be using the same 'dev' that fsldma
uses to allocate the DMA descriptors?  I wonder if the 'dev' should be
allocated internally by dmaengine, or provided by the client drivers.

-- 
Timur Tabi
Linux kernel developer at Freescale
