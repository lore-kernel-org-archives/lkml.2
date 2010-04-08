Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab0DHGgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:36:08 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:51205 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151Ab0DHGgC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:36:02 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Apr 2010 08:35:08 +0200
Subject: RE: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
Thread-Topic: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
Thread-Index: AcrWrHhQuI2f4vfkSZ6458GAPHFLWgANXicA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
 <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
In-Reply-To: <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan]

> > I suggest putting these into Andrews tree now, since:
> >
> > A) 4 of the patches it touches MMCI code which is hanled
> >   by Andrew
> 
> Ok, but it looks like they do not have a build dependency on dma bits
> so they could be merged separately i.e. on top of the async_tx branch.

Well:

[PATCH 04/11] ARM: define the PrimeCell DMA API v5
Is independent. (One .h-file.)

[PATCH 05/11] ARM: add generic PrimeCell interface to COH 901 318 v5
[PATCH 06/11] ARM: add generic PrimeCell interface to DMA40 v1
Depends on 04 AND has a merge dependency on the recent patches for generic
channel control and status, and then the DMA40 driver which is now
Picked into Andrews -mm. So the whole thing does depend on async_tx
HEAD.

Is it possible to move the two DMA40 patches over from -mm to async_tx
to atleast lower the complexity a little bit? (Should be to just
apply them...)

If this is done, you could apply the above three patches to the
async_tx tree.

[PATCH 07/11] ARM: add PrimeCell generic DMA to MMCI/PL180 v5
This is where is starts to get complicated because this patch
Depends on 01, 02, 03, 04. So it has to be applied to a tree
which contains all of it.

[PATCH 08/11] ARM: add PrimeCell generic DMA to PL011 v5
Just depends on 04 (that's the idea, a generic PrimeCell interface)
so could be applied to the async_tx tree
if the others go in there.

[PATCH 09/11] ARM: add PrimeCell generic DMA to PL022 v5
Same thing, plus it is Acked-by: Grant and OK to merge into
async_tx if 04 is there.

[PATCH 10/11] ARM: config U300 PL180 PL011 PL022 for DMA v5
[PATCH 11/11] ARM: config Ux500 PL011 PL022 for DMA v1
These should go in through the ARM tree really, it's platform
data.

> > B) It extends the DMA40 driver which is now pending in
> >   his tree as well.
> >
> > C) Since there doesn't seem to be any consensus of whether
> >   this is the right way forward, it needs some wider
> >   testing I believe.
> 
> No consensus with respect to which pieces, the Primecell driver or
> something outside of drivers/dma?  Forgive me for missing recent
> conversations if this has been discussed to death already.

Well, I'd want Russell to comment on that, I think from the
PrimeCell point of view it is important that the file we put
in place in <linux/amba/dma.h> is something that will really
be likely to a good path forward for all PrimeCell and derivates.
And I really would like Russell to ACK that first, he historically
watches over the PrimeCell stuff.

But that said I think we're pretty solid:
- Implementation for three vastly different PrimeCells
- Implementation for two vastly different DMA engines
- It works in these combos (we've had lots of internal testing on these)

> I can go ahead and queue up the dma bits unless you would prefer, and
> Andrew agrees, to take this all through the -mm tree?

If it's OK with Russell, putting 04-06 plus 09 through async_tx 
tree is a good starter.

07 is problematic and require the entire series to be applied
in one go, 08 could be applied as well but needs Russells ACK.

Yours,
Linus Walleij

