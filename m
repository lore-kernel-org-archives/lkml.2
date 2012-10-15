Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2JOVjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:39:22 -0400
Received: from antcom.de ([188.40.178.216]:57428 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927Ab2JOVjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:39:20 -0400
Message-ID: <507C8268.5030409@antcom.de>
Date: Mon, 15 Oct 2012 23:38:48 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        =?UTF-8?B?RGFu?= =?UTF-8?B?aWVsIEdsw7Zja25lcg==?= 
	<daniel-gl@gmx.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-3-git-send-email-stigge@antcom.de> <20121015180702.GA12801@game.jcrosoft.org> <20121015181928.GB27923@kroah.com> <CACRpkdZmg4+7Zjm2UJktt1uKvytUW3uaYtKz0nJvLeM2MMSV-Q@mail.gmail.com>
In-Reply-To: <CACRpkdZmg4+7Zjm2UJktt1uKvytUW3uaYtKz0nJvLeM2MMSV-Q@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/12 22:30, Linus Walleij wrote:
> I don't like it either, basically because the GPIO sysfs is not
> entirely sound.
> 
> Another patch that is circulating concerns edge triggers and similar,
> and it appear that some parts of the GPIO sysfs is for example
> redefining and exporting IRQchip properties like trigger edge
> in sysfs, while the settings of the irqchip actually used by the driver
> is not reflected in the other direction. So you can *set* these things
> by writing in the GPIO sysfs, but never trust what you *read* from
> there. And you can set what edges an IRQ will trigger on a certain
> GPIO, and the way to handle the IRQs from usespace is to poll
> on a value. This is not really documented but well ...

I'm not convinced this generally also applies to the block GPIO patches.
Or that it can't be fixed.

> The reason an ioctl() IMO is better suited to do the job is that
> it can properly represent a multiple-value operation on several
> GPIOs at the same time in a struct, and it can conversely inform
> userspace about which GPIOs may be a block of signals that
> can be fired simultaneously instead of going to string parsing
> and binary values in sysfs which look like worse hacks to me.

There is no binary values in the sysfs for the block GPIO patches, and
regarding string parsing - yes, that's sysfs. :-)

Roland
