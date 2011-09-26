Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1IZLYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:24:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1IZLYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:24:01 -0400
Date: Mon, 26 Sep 2011 13:21:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Wu, Josh" <Josh.wu@atmel.com>
cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Subject: RE: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on
 sam9m10/sam9g45 board.
In-Reply-To: <4C79549CB6F772498162A641D92D532802D2C262@penmb01.corp.atmel.com>
Message-ID: <Pine.LNX.4.64.1109261318501.9168@axis700.grange>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
 <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109220911500.11164@axis700.grange> <20110924052609.GI29998@game.jcrosoft.org>
 <4E804440.7030709@atmel.com> <Pine.LNX.4.64.1109261130270.9168@axis700.grange>
 <4C79549CB6F772498162A641D92D532802D2C262@penmb01.corp.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:502eZrG6mIQhXEEj1qWpQ2nBTguaRnbGWXbe34qNgml
 Rt3Sgjfj1TA/bQCNzttfTzVWSf4NhhplajAPp/BvO8SXdwZQzE
 2oBgv7zzm8eVFDMMYLc91OCQyJr+4gDCWjmRKgiTywR7gKfYWL
 a/1wkK3z95YMqOCmXjjSC4flZr2WrzEJsA9s9zwJKhO1sC/KEO
 8u0Uy1HapdSfZTX2Y0pIUEznleWQnQl+xlaxrxMpu6NOK/TEl3
 +F74SYCoHbXtFodAhrbhC/di8fIuEyaeeVgziu7fBBr2e8ERrC
 2CZKnkAB4A0fZMAtIadQ+p6z1km3kk1xQdrvFjoZQh20Sm6VY7
 YsQb/vXjpgMnTfZHS4OEdja0ZM0iZqRpWIt3EzXKR9JuHAsXOt
 yrkEy5ILvpIyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011, Wu, Josh wrote:

> On Thu, 22 Sep 2011, Guennadi wrote:
> 
> > On Thu, 22 Sep 2011, Josh Wu wrote:

[snip]

> >> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> >> index e04c5fb..5e23d6d 100644
> >> --- a/arch/arm/mach-at91/at91sam9g45.c
> >> +++ b/arch/arm/mach-at91/at91sam9g45.c
> >> @@ -201,6 +201,7 @@ static struct clk *periph_clocks[] __initdata = {
> >>  	// irq0
> >>  };
> >>  
> >> +static struct clk pck1;
> 
> > Hm, it really doesn't need any initialisation, not even for the .type 
> > field? .type=0 doesn't seem to be valid.
> 
> This line is only a forward declaration. Since the real definition is behind the code we use it.
> It defined in later lines:
> 
> static struct clk pck1 = {
>          .name           = "pck1",
>          .pmc_mask       = AT91_PMC_PCK1,
>          .type           = CLK_TYPE_PROGRAMMABLE,
>          .id             = 1,
> };

Ehem, yes, that's why I'm not very fond of forward declarations of 
structs... Without looking at the code - would it be possible to swap the 
order while still preserving clean source-code structure?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
