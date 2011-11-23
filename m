Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1KWROF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:14:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13156 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1KWROD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:14:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 23 Nov 2011 09:13:58 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 09:13:56 -0800
Subject: RE: bug of gpio transition in pinmux driver
Thread-Topic: bug of gpio transition in pinmux driver
Thread-Index: Acyp4axiJuu++zGnRrW4O4PKta48IAAIWI9Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C6DC@HQMAIL01.nvidia.com>
References: <CAN1soZyX-jJAw4UcQUkgaYC9YosB1znbcFwiijjkyvidPXgp4w@mail.gmail.com>
In-Reply-To: <CAN1soZyX-jJAw4UcQUkgaYC9YosB1znbcFwiijjkyvidPXgp4w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haojian Zhuang wrote at Wednesday, November 23, 2011 6:13 AM:
> Hi Linus & Stephen,
> 
> There's a bug in pinmux driver. We can request gpio via
> pinmux_request_gpio(@gpio). @gpio is the gpio number.
> 
> In pinmux_request_gpio():
>     pin = @gpio - range->base;
>     pin_request(pin);
> 
> This pin is the index of pinctrl_pin_desc[]. What's the definition of
> pinctrl_pin_desc's index? It's the index of PAD, not GPIO. Since the
> goal of pinmux_request_gpio() is to avoid define too much gpio groups.
> We need to add the transition between gpio and pad. It's clear that
> the transition of "pin = @gpio - range->base" can't fit every silicon.

> Especially, one gpio can be routed to two pads in PXA silicon.

That particular case isn't really covered yet; we've been discussing how
to solve that case; see:

https://lkml.org/lkml/2011/11/21/370

-- 
nvpublic

