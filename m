Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1GGTh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:37:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62933 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1GGThz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9403024F5420@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	<20110609124723.GA24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	<1307686140.10976.111.camel@vkoul-udesk3>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE3405@dbde02.ent.ti.com>
	<1307724439.10976.188.camel@vkoul-udesk3>
	<E0D41E29EB0DAC4E9F3FF173962E9E9403020B7C2A@dbde02.ent.ti.com>
	<1308203119.10976.234.camel@vkoul-udesk3>
	<E0D41E29EB0DAC4E9F3FF173962E9E9403024F5420@dbde02.ent.ti.com>
Date: Thu, 7 Jul 2011 21:37:53 +0200
X-Google-Sender-Auth: S6b_IEoW5wlw8mE5EGSVMLWdfPw
Message-ID: <CAKnu2MorpLQuzwDGBJ7uSt6NOk=9vgeBN4f+Zx=CSU9okqzvGw@mail.gmail.com>
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
From: Linus Walleij <linus.walleij@linaro.org>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/7 Raju, Sundaram <sundaram@ti.com>:

> | Just put some enumerator in enum dma_ctrl_cmd in
> | dmaengine.h such as SDMA_TEXAS_STRIDE_CONFIG and call
> | like this:
> |
> | /* However that config struct needs to look, basically */
> | static struct sdma_ti_stride_cgf = {
> |      take = M,
> |      skip = N,
> | };
> |
> | ret = chan->device->device_control(chan, SDMA_TEXAS_STRIDE_CONFIG,
> | &sdma_ti_stride_cfg);
> |
> | Or something like this.
>
> I think this is better option than your 2b. This requires just an addition of
> one more enum in the dma_ctrl_cmd. What do you think about this?
> If Dan and you are okay with this I will send a small patch for this asap.

I think this is the best way to solve it atleast. It's clear what is
being done, and it's easy for a client trying to create such a slave
transfer to back out if it turns out that the DMAC in use does not
support this striding.

Send a patch out and I'll Ack it, FWIW.

Linus Walleij
