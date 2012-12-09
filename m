Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572Ab2LIWgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 17:36:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57333 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab2LIWgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:36:48 -0500
MIME-Version: 1.0
In-Reply-To: <20121209170754.GA27468@roeck-us.net>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
 <CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
 <20121207145955.GA28704@roeck-us.net> <20121207164906.08b65046@pyramind.ukuu.org.uk>
 <1355047099.1673.5.camel@anish-Inspiron-N5050> <20121209110319.459a762a@pyramind.ukuu.org.uk>
 <20121209170754.GA27468@roeck-us.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 9 Dec 2012 22:36:27 +0000
X-Google-Sender-Auth: XCBhtw-jagC9hZZnku0NRM8ljoY
Message-ID: <CACxGe6sXt6cMeTa=R3n_Lqoy8w9AXoOOA-r5Csn54A=9wMzZaw@mail.gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
To: Guenter Roeck <groeck-dsl@sbcglobal.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        anish kumar <anish198519851985@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 9, 2012 at 5:07 PM, Guenter Roeck <groeck-dsl@sbcglobal.net> wrote:
> On Sun, Dec 09, 2012 at 11:03:19AM +0000, Alan Cox wrote:
>> On Sun, 09 Dec 2012 01:58:19 -0800
>> anish kumar <anish198519851985@gmail.com> wrote:
>>
>> > On Fri, 2012-12-07 at 16:49 +0000, Alan Cox wrote:
>> > > > I could imagine declaring the activity request buttons to be "input", but for
>> > > > presence detects it is a bit far fetched and would add too much complexity.
>> > >
>> > > Android tries to address this with its switch class driver, but I'm not
>> > > sure its actually got anything over making them input devices.
>> >
>> > Sorry for not understanding the context here.How the debounce sysfs
>> > added by Guenter has anything to do with switch driver in android?
>>
>> The other more general option is to make the input layer do the debounce
>> and make them all inputs rather than just relying on any gpio layer
>> support.
>>
> The gpio pins I am dealing with are provided by an FPGA which is used on various
> boards. While the gpio access registers are always the same, the actual usage is
> board specific. This means I either need to write ugly code, or use the gpio
> subsystem to provide access to the gpio pins. Ugly code is out of the question,
> which means I'll need gpio support.
>
> Anyway, I want to keep things simple, not add unnecessary complexity. Having to
> go through the input subsystem just to be able to support debounce on a couple
> of input pins doesn't really sound simple. Guess I'll have to find another
> solution if the patch is not accepted. Maybe I'll add a "debounce" property to
> the gpio driver's of properties.

I haven't looked deeply at the patch to give you an answer yet, but
I'd recommend you go with the DT property approach anyway. The gpio
sysfs interface is horribly designed and I'm not keen on adding new
features to it.

g.
