Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1JQMIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:08:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40630 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1JQMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:08:17 -0400
Date: Mon, 17 Oct 2011 13:08:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111017120813.GB27266@opensource.wolfsonmicro.com>
References: <20111013204410.GA17160@sirena.org.uk>
 <4E985C60.9020308@cam.ac.uk>
 <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
 <4E9BF8D9.8030301@cam.ac.uk>
 <20111017101959.GC3042@opensource.wolfsonmicro.com>
 <4E9C0423.5010909@cam.ac.uk>
 <20111017104642.GD3042@opensource.wolfsonmicro.com>
 <4E9C0DD7.7080105@cam.ac.uk>
 <20111017111807.GA27266@opensource.wolfsonmicro.com>
 <4E9C1249.5020408@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C1249.5020408@cam.ac.uk>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:32:25PM +0100, Jonathan Cameron wrote:
> On 10/17/11 12:18, Mark Brown wrote:

> >  - Some voltage inputs hard wired to particular system supplies.

> Hard wired in the pmic?  (e.g. do not vary from device to device).
> These I'm happy to see have names.  If it were a normal IIO device their
> access attributes would be something like:

> in_voltage0_supply3V_raw
> in_voltage1_supply2.8V_raw

Yes, though the names are more symbolic than that (eg, "USB").

> (have insist on indexing even with named channels because it is needed as
> events codes don't want to carry a string.).

This is orthogonal to the request interface, though.

> >  - One or more temperature inputs wired to particular place (eg, chip
> >    and battery).

> Not hard wired so to my mind these are just general purpose temperature inputs.
> Hence naming doesn't make sense (at least not outside of board file or DT).

No, they're hard wired - like I say they're wired to a particular place.

> There are some complexities to deal with that make me wonder if direct indexing
> into a driver provided table isn't easier.  The other is channel types.

It's not great for usability if you've got to apply an additional layer
of translation on top of mapping the schematic onto the hardware.

> Is it so bad to insist that the dt writer or equivalent actually looks at the
> driver in question and picks the underlying channel index directly?

We certainly can't put Linux specific channel numbers into the device
tree.
