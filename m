Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2LGO7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:59:34 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53488 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2LGO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:59:32 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 07 Dec 2012 08:59:31 -0600
X-Originating-IP: 108.223.40.66
Date: Fri, 7 Dec 2012 06:59:55 -0800
From: Guenter Roeck <groeck-dsl@sbcglobal.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
Message-ID: <20121207145955.GA28704@roeck-us.net>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
 <CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 09:07:28AM +0100, Linus Walleij wrote:
> On Thu, Dec 6, 2012 at 7:32 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Create a 'debounce' attribute if debounce is supported by the gpio
> > chip and a gpio pin is exported.
> >
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> Can you describe the usecase for this?
> 
> I have this problem when working as a back-up GPIO maintainer that
> I don't really understand the userspace apps doing this.
> 
> I would guess something like a userspace app reading a GPIO switch
> and needing to set this to avoid key bounces, but it'd be nice to know
> if this is really the case.
> 
Yes, that is one if the use cases. Button pressed on the chassis/board
requesting user space action. Another is board presence detect pins which
require rebounce support and are handled in user space. Yes, the later should be
handled in the kernel, and most of them are, but there are some which don't need
immediate kernel activity and are handled completely by applications.

There may be other use cases - there are hundreds of gpio pins in the system I
am working on, and I have not looked into all of them.

> If this is the usecase I am slightly concerned why these are not used:
> drivers/input/keyboard/gpio_keys_polled.c
> drivers/input/keyboard/gpio_keys.c
> 
> The latter even uses the in-kernel debounce interface.
> 
> I'd agree if this is not user input at all but something like a switch
> in a factory production line.
> 
I could imagine declaring the activity request buttons to be "input", but for
presence detects it is a bit far fetched and would add too much complexity.

Thanks,
Guenter
