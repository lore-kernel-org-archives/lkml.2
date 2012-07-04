Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2GDASZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 20:18:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52562 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2GDASW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 20:18:22 -0400
MIME-Version: 1.0
In-Reply-To: <B9B2E09D-99AF-4B36-AC3A-7000A3FDCCA9@sonatest.com>
References: <B9B2E09D-99AF-4B36-AC3A-7000A3FDCCA9@sonatest.com>
Date: Wed, 4 Jul 2012 09:18:21 +0900
Message-ID: <CANKRQnhp3-vOGJ2ptkEEnm2a8CJKUG0SJho2HzjeRfKjVq5ePA@mail.gmail.com>
Subject: Re: gpio: pch/ml-ioh - leaking struct irq_chip_generic
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: =?ISO-8859-1?Q?Jean=2DFran=E7ois_Dagenais?= 
	<jeff.dagenais@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linus.walleij@stericsson.com
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 4:30 AM, Jean-François Dagenais
<jeff.dagenais@gmail.com> wrote:
> Am I mistaken or these two drivers are missing a "irq_remove_generic_chip()"
> then a "kfree" of the struct's memory in their xyz_remove() callbacks?
>
> Kinda like "drivers/mfd/jz4740-adc.c" does?
>

Current upstreamed GPIO drivers(showed below) use irq_alloc_generic_chip().
    drivers/gpio/gpio-ml-ioh.c
    drivers/gpio/gpio-mxc.c
    drivers/gpio/gpio-pl061.c
    drivers/gpio/gpio-pch.c
    drivers/gpio/gpio-mxs.c
    drivers/gpio/gpio-sodavil
    drivers/gpio/gpio-omap.c

However, no GPIO driver uses irq_remove_generic_chip().

I'm not familiar with these things. So I'm not sure whether
irq_remove_generic_chip is necessary or not.

Could maintainer or specialist of this tell us the information about it ?

thanks.
------
ROHM Co., Ltd.
Tomoya MORINAGA
