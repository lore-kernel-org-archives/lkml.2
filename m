Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2JREix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:38:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46986 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751177Ab2JREiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:38:52 -0400
X-Authenticated: #2770290
X-Provags-ID: V01U2FsdGVkX19lXt9kAU1ljiOi32od9L/6d/xak2nRElkitd7Dfv
	p5V0vYwIeMbhcT
Date: Thu, 18 Oct 2012 06:38:48 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
Message-ID: <20121018043848.GA4022@minime.bse>
References: <1350069085-13283-1-git-send-email-stigge@antcom.de>
 <1350069085-13283-3-git-send-email-stigge@antcom.de>
 <20121015180702.GA12801@game.jcrosoft.org>
 <20121015181928.GB27923@kroah.com>
 <CACRpkdZmg4+7Zjm2UJktt1uKvytUW3uaYtKz0nJvLeM2MMSV-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZmg4+7Zjm2UJktt1uKvytUW3uaYtKz0nJvLeM2MMSV-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
sorry for the late reply. I'm currently on vacation and it is no fun to
use SSH with a 1s latency while Entel Chile injects RST/ACK packets.
I'll read the remaining related mails that have accumulated in my inbox
when I'm back home.

On Mon, Oct 15, 2012 at 10:30:15PM +0200, Linus Walleij wrote:
> Another patch that is circulating concerns edge triggers and similar,
> and it appear that some parts of the GPIO sysfs is for example
> redefining and exporting IRQchip properties like trigger edge
> in sysfs, while the settings of the irqchip actually used by the driver
> is not reflected in the other direction. So you can *set* these things
> by writing in the GPIO sysfs, but never trust what you *read* from
> there. And you can set what edges an IRQ will trigger on a certain
> GPIO, and the way to handle the IRQs from usespace is to poll
> on a value. This is not really documented but well ...

Part of this sounds like you are not familiar with the GPIOlib sysfs
IRQ stuff. The trigger edge set in sysfs is only used when userspace
polls the GPIO via sysfs. Drivers that want to register a gpio IRQ
should IMHO always explicitly request the edge/level to trigger on and
they should request the gpio beforehand. This prevents the gpio from
being exported to userspace. Only IRQ triggers accepted by the irq chip
are settable in sysfs, so you can trust the value read from that file.

> Sadly the main creator of this ABI is David Brownell who is
> not able to respond nor maintain it from where he is now. But
> we need to think hard about what we shall do with this particular
> piece of legacy. Some of the stuff was added by Daniel
> Glöckner so requesting advice from him.

I'm only guilty of adding the IRQ sysfs interface.

> Daniel: are you interested in helping us fixing the GPIOlib
> sysfs ABI and kernel internals? I'm a bit afraid of it.

Actually I don't know what you want to change to fix the existing sysfs
ABI. Personally I'd like to see the following things changed:
 - /sys/gpio/.../direction does not correspond to hardware before first
   use of gpio_direction_* due to lack of gpio_get_direction.
 - Names given to gpios by the chip should just result in symlinks to
   the usual gpioX directories or (un)exporting of gpios should accept
   names.

Best regards,

  Daniel
