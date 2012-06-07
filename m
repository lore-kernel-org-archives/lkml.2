Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab2FGVxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:53:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33925 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab2FGVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:53:08 -0400
Date: Thu, 7 Jun 2012 22:53:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] gpiolib: wm8994: Pay attention to the value set when
 enabling as output
Message-ID: <20120607215305.GA19760@sirena.org.uk>
References: <1338916327-3958-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdY379kHbaMhGD4Q9y=Nkv2NPey+n1zUuTLAE-j7f8gadA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY379kHbaMhGD4Q9y=Nkv2NPey+n1zUuTLAE-j7f8gadA@mail.gmail.com>
X-Cookie: Is there life before breakfast?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 01:11:20PM +0200, Linus Walleij wrote:
> <broonie@opensource.wolfsonmicro.com> wrote:

> > + ? ? ? if (value)
> > + ? ? ? ? ? ? ? value = WM8994_GPN_LVL;

> > ? ? ? ?return wm8994_set_bits(wm8994, WM8994_GPIO_1 + offset,
> > - ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?WM8994_GPN_DIR, 0);
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?WM8994_GPN_DIR | WM8994_GPN_LVL, value);
> > ?}

> The commit message is so terse compared to what the code does that
> I cannot claim to understand what this patch is doing.

> Could you elaborate on the problem ans symptoms, just for a nice
> commit log?

I'm not really sure what more there is to say...  previously we were
ignoring the value that's set as part of setting output mode so if
someone wanted to set a value different to the one the chip happened to
have that wouldn't happen.  Ignoring the vaue that the user is trying to
set seems like an obvious enough bug in itself.
