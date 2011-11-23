Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1KWRZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:25:40 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64342 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1KWRZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C6DC@HQMAIL01.nvidia.com>
References: <CAN1soZyX-jJAw4UcQUkgaYC9YosB1znbcFwiijjkyvidPXgp4w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C6DC@HQMAIL01.nvidia.com>
Date: Thu, 24 Nov 2011 01:25:38 +0800
Message-ID: <CAN1soZyM_E8Y6RvOKXPCsJ5o590QmeLV8JfnAnOhE1y9PJ44Aw@mail.gmail.com>
Subject: Re: bug of gpio transition in pinmux driver
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 1:13 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Haojian Zhuang wrote at Wednesday, November 23, 2011 6:13 AM:
>> Hi Linus & Stephen,
>>
>> There's a bug in pinmux driver. We can request gpio via
>> pinmux_request_gpio(@gpio). @gpio is the gpio number.
>>
>> In pinmux_request_gpio():
>>     pin = @gpio - range->base;
>>     pin_request(pin);
>>
>> This pin is the index of pinctrl_pin_desc[]. What's the definition of
>> pinctrl_pin_desc's index? It's the index of PAD, not GPIO. Since the
>> goal of pinmux_request_gpio() is to avoid define too much gpio groups.
>> We need to add the transition between gpio and pad. It's clear that
>> the transition of "pin = @gpio - range->base" can't fit every silicon.
>
>> Especially, one gpio can be routed to two pads in PXA silicon.
>
> That particular case isn't really covered yet; we've been discussing how
> to solve that case; see:
>
> https://lkml.org/lkml/2011/11/21/370
>
> --
> nvpublic
>
>

Thanks a lot for your quick reply. If you could cc linux-arm-kernel
mailist for the later discussion of pinmux, it would be better.

Best Regards
Haojian
