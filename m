Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2IEA2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:28:31 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:63441 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2IEA23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:28:29 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 04 Sep 2012 17:00:08 -0700
Message-ID: <50469CAC.7050608@synaptics.com>
Date: Tue, 4 Sep 2012 17:28:28 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 14/17] input: RMI4 F30 GPIO/LED control
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <1345241877-16200-15-git-send-email-cheiny@synaptics.com> <CACRpkdYc68j24VZAMxLoC-7-sWn4bJPtxA5U6a95Dg82+zTetg@mail.gmail.com>
In-Reply-To: <CACRpkdYc68j24VZAMxLoC-7-sWn4bJPtxA5U6a95Dg82+zTetg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 03:58 PM, Linus Walleij wrote:
> GPIO/LED, nice since I'm a GPIO maintainer I'll take a closer look.
>
> If the bus will start doing a lot of non-input business it should live under
> drivers/mfd but I think this is just one exception, right?
>
> On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:
>
> (...)
>> diff --git a/drivers/input/rmi4/rmi_f30.c b/drivers/input/rmi4/rmi_f30.c
>
>> +#include <linux/kernel.h>
>> +#include <linux/rmi.h>
>> +#include <linux/input.h>
>> +#include <linux/slab.h>
>> +#include "rmi_driver.h"
>
> The non-existance of <linux/gpio.h> and <linux/leds.h> tells us that something
> is very wrong.
>
> You should not model these GPIOs and LEDs by a set of obscure
> sysfs attributes, instead use the proper kernel subsystems that
> already exist for handling this! LEDs and GPIOs already have their
> own (standardized) userspace sysfs interfaces.
>
> Reading the code I see that this is what happens here, so please rewrite
> this to be a real GPIO+LED driver using struct gpio_chip and
> the same for LEDs.
>
> Be inspired by drivers/gpio/* and drivers/leds/*

Roger.  We'll rework this and resubmit at a later date.
