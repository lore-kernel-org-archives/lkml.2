Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0IWVbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:31:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41849 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0IWVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cnN/y5CTagQomxTo2kviV9y7t+jWpCWBPw3gkk5dgqL0c0SpniBfVYxjHC9wi5UUeK
         /wpJz6SrZyl1IRYkWFlteNQ3JnUQk+TO8mpNdRtZaxxMEE7ZD+FscdEw9uXNzOADXaKC
         cFrJ2KTUdC4WJ8+xgofDlm0tsUwcNI7yB88Ks=
MIME-Version: 1.0
In-Reply-To: <1283354665-8673-2-git-send-email-linus.walleij@stericsson.com>
References: <1283354665-8673-1-git-send-email-linus.walleij@stericsson.com>
	<1283354665-8673-2-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 23 Sep 2010 14:31:22 -0700
X-Google-Sender-Auth: adpO3W6DSVEFJVAQJACcbWLGx4Q
Message-ID: <AANLkTinoGjwWjqHQx-+UB+9K+s97t9c0y5i5-rdw=UA4@mail.gmail.com>
Subject: Re: [PATCH 1/6] ARM: add PrimeCell generic DMA to PL022 v10
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 1, 2010 at 8:24 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This extends the PL022 SSP/SPI driver with generic DMA engine
> support using the PrimeCell DMA engine interface. Also fix up the
> test code for the U300 platform.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> As mentioned I have no clue to why this failed to compile for Grant,
> please see if this tenth version is still problematic or if it was
> something intermittent.
>
> Else I really need help in knowing what config to compile, this was
> compiled for U300, U8500 and RealView with and without DMA enabled.

Maybe it makes more sense for these filter_id functions to be defined
in the arch code rather than the dma driver.  Right now there seems to
be a weird dependency of arch requires dma-driver, dma-driver requires
arch, and slave-driver requires arch and dma-driver in order to
dynamically select dma-driver with dma_request_channel().  It forces
dma-driver and slave-driver to always be compiled in, if I am reading
this correctly.

--
Dan
