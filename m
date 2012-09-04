Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2IDGiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:38:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62745 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2IDGis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:38:48 -0400
MIME-Version: 1.0
In-Reply-To: <5044AB51.3040106@yahoo.es>
References: <50439D44.3080100@yahoo.es>
	<CAHp75VcQOeVeKPg8z9u+fd8ia4QAyrq6UQn-D7Q-yO9+pLS6LQ@mail.gmail.com>
	<CAKohpo=bvzm1O4FAtsr3YpLg-w1Rp7RT-9ZuJBgVZRxVHnQO_g@mail.gmail.com>
	<CAHp75VcpzomoWb3+xOk=++BkUh5_cuXQTu8ZuDByjfX+pYmNCA@mail.gmail.com>
	<CAKohpomFDuTFVJ8SCmhRmPbCXMWdhD1Acjs5CAZD4aeqLZnurA@mail.gmail.com>
	<5044AB51.3040106@yahoo.es>
Date: Tue, 4 Sep 2012 09:38:47 +0300
Message-ID: <CAHp75VdQV+nZzvp8OK+vZtqnC34nj_PwVK0EdGS1_AYhDDfv=w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] dw_dmac: max_mem_width limits value for
 SRC/DST_TR_WID register
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 4:06 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> 1. The first draft of the patches worked with the max allowable value for
> the SRC_WIDTH & DST_WIDTH fields: 0,1,2,3... Viresh thought it was not
> transparent enough, he suggested to make it simpler with a binary choice of
> 32- or 64-bits, defaulting to 64-bits.
> But Andy is right: there are versions supporting 256-bit wide memory transfers.
> I'd also go for this previous solution and use: "min(max_mem_width, width)"
>
> The only problem is that one doesn't want to change arch code for other
> platforms (ARM) so I proposed: let "max_mem_width=0" mean: leave it up to
> the driver, for now 3 : 64-bits.
Sounds better to support all possible options without any additional
layer of conversion, isn't it?

> 2. In another version I made 'max_mem_width' a member of 'dw_dma_platform_data'
> because I also see it as 'constant' for all dma slaves.
> But the dw_dmac controller can be used for multiple (types of) memories
> and in that case, maybe a limit per slave might be desirable? My knowledge
> of DMA-hardware doesn't reach far enough to judge that.
As Viresh told early that will not cover memory-to-memory transfers.

> I'd say: for now let it become a member of 'dw_dma_platform_data' because
> it's the max value of a register field.
I support such choice.

> 3. Felipe Balbi: why don't we ask the DW IP for its maximum allowed value of
> SRC_WIDTH & DST_WIDTH (on the memory side)? Sure, would be elegant!
It's not so simple, unfortunately.

> Alternatively, we could do a small dma-memcpy-test at start-up and try all
> values from 5 (or 7) down to 2. The first value that works correctly will be
> used as the maximum.
Oh, it might be good idea to get this value in case neither IP nor
platform data provides it.
I'm pretty sure the platform device driver has to know this beforehand.

-- 
With Best Regards,
Andy Shevchenko
