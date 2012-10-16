Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2JPIqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:46:10 -0400
Received: from 5.mo4.mail-out.ovh.net ([188.165.44.50]:54060 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752567Ab2JPIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:46:07 -0400
Date: Tue, 16 Oct 2012 10:43:27 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>,
        Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
Message-ID: <20121016084327.GC12801@game.jcrosoft.org>
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
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2213237742585228253
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:30 Mon 15 Oct     , Linus Walleij wrote:
> I really request Grant to comment on this...too.
> 
> On Mon, Oct 15, 2012 at 8:19 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Oct 15, 2012 at 08:07:02PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> On 21:11 Fri 12 Oct     , Roland Stigge wrote:
> >> > This patch adds sysfs support to the block GPIO API.
> >> >
> >> > Signed-off-by: Roland Stigge <stigge@antcom.de>
> >> >
> >> > ---
> >> >  Documentation/ABI/testing/sysfs-gpio |    6
> >> >  drivers/gpio/gpiolib.c               |  226 ++++++++++++++++++++++++++++++++++-
> >> >  include/asm-generic/gpio.h           |   11 +
> >> >  include/linux/gpio.h                 |   13 ++
> >> >  4 files changed, 254 insertions(+), 2 deletions(-)
> >> I really don't like this sysfs we need to add a specific device with ioctl
> >
> > Why?
> 
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
> 
> Part of me just want to delete that, but I can't because it's now
> an ABI.
> 
> The "devices" that the sysfs files are tied to are not real devices,
> instead the code look like this: whenever a gpio is exported to
> sysfs, the code calls (drivers/gpio/gpiolib.c):
> 
>     dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
>                     desc, ioname ? ioname : "gpio%u", gpio);
> 
> Mock device just to get a sysfs opening. And once device for
> every GPIO with no hierarchical correspondence to anything
> in the system.
> 
> The thing is that struct gpio_chip is not a device at all, it's something
> else.
> 
> This inconsistency in the GPIO sysfs implementation make me
> fear adding new stuff to it. The other problems need fixing first.
> 
> The reason an ioctl() IMO is better suited to do the job is that
> it can properly represent a multiple-value operation on several
> GPIOs at the same time in a struct, and it can conversely inform
> userspace about which GPIOs may be a block of signals that
> can be fired simultaneously instead of going to string parsing
> and binary values in sysfs which look like worse hacks to me.
> 
> The last thing I'm a bit softer on though. Mainly I fear of this
> sysfs ABI growing into a beast.
> 
> It was all merged prior to Grant becoming maintainer and
> me becoming co-maintainer of it, so this is legacy business.
> 
> Sadly the main creator of this ABI is David Brownell who is
> not able to respond nor maintain it from where he is now. But
> we need to think hard about what we shall do with this particular
> piece of legacy. Some of the stuff was added by Daniel
> Glöckner so requesting advice from him.
> 
> Daniel: are you interested in helping us fixing the GPIOlib
> sysfs ABI and kernel internals? I'm a bit afraid of it.
My 0.02$ too

Best Regards,
J.
