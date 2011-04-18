Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1DRHR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:17:28 -0400
Received: from gate.eia.be ([194.78.71.18]:33609 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1DRHRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:17:21 -0400
Date: Mon, 18 Apr 2011 09:17:16 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110418071716.GA334@kurt.e-circ.dyndns.org>
Mail-Followup-To: Kyungmin Park <kmpark@infradead.org>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTinnscZeaHkuMme1h-mxGrpJhmZ_Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BANLkTinnscZeaHkuMme1h-mxGrpJhmZ_Xg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Apr 2011 07:14:16.0265 (UTC) FILETIME=[3A268390:01CBFD98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The interface proposed here is a lot better than most ad hoc implementation.
But similar to what Kyungmin Park noticed, I doubt the usefulness
of a limited enumeration for all different types.

On one hand, upper layers benefit from a limited list (like proposed).
On the other hand, most SoC's have more options, which are not comparable.

How will this interface cope with such differences?
a) ignore SoC specifics
b) export it through an _unlimited_ enumeration
c) export it via some GPIO_DRIVE_PROPRIETARY+X where X is very
   SoC dependant.

Any suggestions?

Kurt

On Mon, Apr 18, 2011 at 09:09:28AM +0900, Kyungmin Park wrote:
> Hi Linus,
> 
> It's really required feature for ARM architectures.
> In case of samsung SoCs. it needs more things you described.
> In case of setting the drive, we can set the drive strength, 1x, 2x, 3x, and 4x.
> So can it add the more like this? or separate enumeration?
> 
> > +enum gpio_drive {
> > +       GPIO_DRIVE_PUSH_PULL,
> > +       GPIO_DRIVE_OPEN_DRAIN,
> > +       GPIO_DRIVE_OPEN_SOURCE,
>             GPIO_DRIVE_STRENGTH_1X,
>             GPIO_DRIVE_STRENGTH_2X,
>             GPIO_DRIVE_STRENGTH_3X,
>             GPIO_DRIVE_STRENGTH_4X,
> > +};
> 
> or
> 
> enum gpio_drive_strength {
>             GPIO_DRIVE_STRENGTH_1X,
>             GPIO_DRIVE_STRENGTH_2X,
>             GPIO_DRIVE_STRENGTH_3X,
>             GPIO_DRIVE_STRENGTH_4X,
> };
> 
> Thank you,
> Kyungmin Park
> 
> On Mon, Apr 18, 2011 at 6:37 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > This adds two functions for struct gpio_chip chips to provide pin
> > bias and drive mode settings for individual pins. Implementers does
> > this a bit differently and usually there are a few possible modes you
> > can select, I'm providing a few common modes for biasing and driving
> > pins.
> >
> > Since we have no previous hacked-up arch-specific drivers for this
> > we can avoid any __override_functions and we just allow this to be
> > properly implemented using gpiolib. Further the function is made
> > non-mandatory, if it is not defined for the chip it will be silently
> > ignored.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[...]
