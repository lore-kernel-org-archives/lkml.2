Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0HaMPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:15:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0HaMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=to4CR7sXkabDnvJWj3fNsdOxc1qvc7HQJyJzWjvQZSBJZdPyQb3BUOXyGn8hp143gk
         M8OBC6cSEpR2l1HQ183z48kHN2bMlkQoYoNyuFLlthHlGODyed+VDhT8HEoD0rLadEl5
         l/BhrpT0X1jio0pZk8JZ+Ci8OAcLtSUZOzCPo=
MIME-Version: 1.0
In-Reply-To: <20100831110758.GD20849@rakim.wolfsonmicro.main>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
	<20100827190306.GB20407@void.printf.net>
	<AANLkTi=20KrUy334JRmMYwK7rbaVYrYCqW-BHZYGPrwT@mail.gmail.com>
	<20100829132711.GB10233@opensource.wolfsonmicro.com>
	<AANLkTim+cOSt=kjXXh_w+b4mzCiZN76HQ3az7SJKmOxR@mail.gmail.com>
	<20100831110758.GD20849@rakim.wolfsonmicro.main>
Date: Tue, 31 Aug 2010 14:15:07 +0200
Message-ID: <AANLkTimN0cSzp8756frWvQQpaUCy+3ydVg+JYD9LxHLc@mail.gmail.com>
Subject: Re: [PATCH] mmc: move regulator handling to core
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Chris Ball <cjb@laptop.org>, Daniel Mack <daniel@caiaq.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Pierre Ossman <pierre@ossman.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        Madhusudhan <madhu.cr@ti.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/31 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Sun, Aug 29, 2010 at 05:30:48PM +0200, Linus Walleij wrote:
>> 2010/8/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > This seems like the wrong approach; if there's a problem it'd seem much
>> > better to fix the core code that everything is sharing rather than
>> > factor it out - the location of the code is orthogonal to its
>> > helpfulness.
>
>> I actually did not move the essential regulator bits out just enable/disable,
>> so that these were in the sites where the regulators were actually
>> enabled/disabled in respective driver. That makes the internal
>> regulator reference count do the trick.
>
> I'm not sure what "the sites where the regulators were actually
> enabled/disabled in respective driver" are but my understanding was that
> there's a bit of an issue here in that the MMC core does not guarantee
> balanced enable/disable calls.

Yeah I figured out what you wanted and sent an updated patch, check
it out. I'll just weave in some comments from Adrian and it'll do things
the way you want it I believe.

Yours,
Linus Walleij
