Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1EYJJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:09:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48900 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1EYJJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=epfVaIdCVKgi4FWg4AJ4Bil/F4R+XLFITXDJc9CSoRPlkMQ9cSGEIu8Wey8OBKC1m2
         JqAIeqR8ULHYMMIuLyAbfJ4qbewMvmJdx0zFmaJDZjxUAqOAS76Q0ugJchWLvDf1UcJk
         IjgbfEZiDPDiHW++QfVHneVbgcLCy8VtFTkmc=
MIME-Version: 1.0
In-Reply-To: <1306311593.30236.103.camel@vkoul-udesk3>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
	<e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
	<BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
	<1306311593.30236.103.camel@vkoul-udesk3>
Date: Wed, 25 May 2011 11:09:26 +0200
X-Google-Sender-Auth: PkcuHmsG9_OxfCnWdYd6ajLRZ6c
Message-ID: <BANLkTi=X4XH0FL4HFXi4ZsJYy2O=mjnctg@mail.gmail.com>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Koul, Vinod <vinod.koul@intel.com>:
> On Wed, 2011-05-25 at 10:39 +0200, Linus Walleij wrote:
>> 2011/5/22 Mika Westerberg <mika.westerberg@iki.fi>:
>>
>> > The ep93xx DMA controller has 10 independent memory to peripheral (M2P)
>> > channels, and 2 dedicated memory to memory (M2M) channels. M2M channels can
>> > also be used by SPI and IDE to perform DMA transfers to/from their memory
>> > mapped FIFOs.
>>
>> No so much a review comment as an observation: I opposed the merge of the
>> EP93xx SPI driver in drivers/spi/ep93xx_spi.c on the grounds that it was close
>> enough to amba-pl022.c that it could use that driver instead.
>>
>> One of the arguments against was that you were going to do custom DMA
>> and stuff. Now you're using the DMAengine, so can you please reconsider
>> refactoring amba-pl022.c to suit your needs and you'll get DMA support for
>> free mor or less.
>
> Linus is the dma IP same as existing ones?
> In that case we shouldn't have a new driver for same IP.

Nope, not as far as I can tell. The fear of this IP being an amba-pl08x.c
already hit med so I checked the register map, but it appears to be unique.
I haven't compared it to amba-pl330.c though.

Yours,
Linus Walleij
