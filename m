Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1EYIjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:39:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36740 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab1EYIjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VKlyLhU4NgsFMB7AOLxgk9LlFUlS/Shvq/wifDk4ghrkNOjLOvUiOL0ODAzNLZP5XP
         FiCpRYzsfTVDK642EHdQkfupAXWK+RtPp93X3omhKiNQ0o3tDMNMdV+DIfswdGHrBqKj
         5DiKl/Ax/HFq2IjPZ4BA7y2CUH90nBqqMF8aA=
MIME-Version: 1.0
In-Reply-To: <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
	<e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
Date: Wed, 25 May 2011 10:39:52 +0200
X-Google-Sender-Auth: rvPZQt6VKK6IjSbcDGuMsiPC5iw
Message-ID: <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/22 Mika Westerberg <mika.westerberg@iki.fi>:

> The ep93xx DMA controller has 10 independent memory to peripheral (M2P)
> channels, and 2 dedicated memory to memory (M2M) channels. M2M channels can
> also be used by SPI and IDE to perform DMA transfers to/from their memory
> mapped FIFOs.

No so much a review comment as an observation: I opposed the merge of the
EP93xx SPI driver in drivers/spi/ep93xx_spi.c on the grounds that it was close
enough to amba-pl022.c that it could use that driver instead.

One of the arguments against was that you were going to do custom DMA
and stuff. Now you're using the DMAengine, so can you please reconsider
refactoring amba-pl022.c to suit your needs and you'll get DMA support for
free mor or less.

Yours,
Linus Walleij
