Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2JPVIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:08:53 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:44625 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2JPVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <20121016174038.GA17982@kroah.com>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
	<1350343887-7344-3-git-send-email-stigge@antcom.de>
	<20121015235720.GA3132@kroah.com>
	<507D58D9.2040607@antcom.de>
	<20121016164326.GA4858@kroah.com>
	<CACRpkdYaaSt9uLN2_=KXYDK2b5D5paopsYxgYKqezKCx8cy=vQ@mail.gmail.com>
	<20121016174038.GA17982@kroah.com>
Date: Tue, 16 Oct 2012 23:08:51 +0200
Message-ID: <CACRpkdb+hu1Q=P8wBWts1RsMFQYuDMuszS74Z5mmkfwcXdpEpw@mail.gmail.com>
Subject: Re: [PATCH RFC 02/11 v4] gpio: Add sysfs support to block GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Roland Stigge <stigge@antcom.de>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 7:40 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 16, 2012 at 07:27:15PM +0200, Linus Walleij wrote:
>> The thing is, as I've tried to explain but maybe didn't get across,
>> that these devices don't *have* a parent, and are not part of any
>> tree.
>
> You are passing in a parent device to the device_create() call, where
> did that pointer come from?

You mean this:

dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
                        desc, ioname ? ioname : "gpio%u", gpio);

desc->chip->dev is an *optional* pointer to a parent device of
the GPIO chip (not the GPIO chip itself). It is usually NULL.

>> They are parentless mock devices, created on-the-fly just to get
>> sysfs entries.
>
> That's fine, well, not the "parentless" part, but that should be trivial
> to fix, just pass in the correct pointer and you should be fine.

Hm, yeah well, they are orphans mostly.

>> What is needed it to get the device model right in the first
>> place.
>
> I thought it was in the device model already?

GPIO chips are not devices. :-(

Yours,
Linus Walleij
