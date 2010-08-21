Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0HUBqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 21:46:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47712 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HUBp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 21:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dDkSosgQmCW6e9FtN0fJTnARtuhVNqHXCEO5yxmWzIGHolz6jWnwlKZjU61XBU4C8P
         nIb1WZgJAHNvdFkwWn1uxkUr3JcqjLW+xLcVZsODq1lVVUIDu96fe2dd8oZwehPcALzj
         b1j+CNGU4Vowr7vOD575Mu7UR8qGBok31ZkRQ=
MIME-Version: 1.0
In-Reply-To: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sat, 21 Aug 2010 10:45:56 +0900
Message-ID: <AANLkTimggbZqgv=eKe+wx8YvUX5vOppDfmwpLwTgxJFM@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 1/2] spi/spi_s3c64xx: Make probe more
 robust against missing board config
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 1:17 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> The S3C64xx SPI driver requires the machine to call s3c64xx_spi_set_info()
> to select a few options, including the clock to use for the SPI controller.
> If this is not done then a NULL will be passed as the clock name for
> clk_get(), causing an obscure crash. Guard against this and other missing
> configuration by validating that the clock name has been filled in in
> the platform data that ets passed in.

     The movement of sci assignment and check doesn't make any
difference because
      we already check for presence of platform_data and DMA-Tx,Rx and
IO base is
      set irrespective of calling s3c64xx_spi_set_info()

    Also, I think !sci->num_cs might be an even better check because
the samsung clock
   api might be changed (IIRC Ben was already working it out) to make
it redundant
   to pass clock name strings to clk_get. If that is the case, we might end up
   adding another foolproof check like !sci->num_cs

    what do you guys think?

regards
