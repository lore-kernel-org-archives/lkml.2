Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1JQMsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:48:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54573 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab1JQMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:48:09 -0400
Date: Mon, 17 Oct 2011 13:48:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111017124807.GD27266@opensource.wolfsonmicro.com>
References: <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
 <4E9BF8D9.8030301@cam.ac.uk>
 <20111017101959.GC3042@opensource.wolfsonmicro.com>
 <4E9C0423.5010909@cam.ac.uk>
 <20111017104642.GD3042@opensource.wolfsonmicro.com>
 <4E9C0DD7.7080105@cam.ac.uk>
 <20111017111807.GA27266@opensource.wolfsonmicro.com>
 <4E9C1249.5020408@cam.ac.uk>
 <20111017120813.GB27266@opensource.wolfsonmicro.com>
 <4E9C201D.30905@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C201D.30905@cam.ac.uk>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 01:31:25PM +0100, Jonathan Cameron wrote:
> On 10/17/11 13:08, Mark Brown wrote:
> > On Mon, Oct 17, 2011 at 12:32:25PM +0100, Jonathan Cameron wrote:

Your mails would be much more legible if you'd leave blank lines between
paragraphs and if you could wrap your mails at less than 80 columns.

> >> (have insist on indexing even with named channels because it is needed as
> >> events codes don't want to carry a string.).

> > This is orthogonal to the request interface, though.

> No it isn't - because it will effect the numbering of the gneral purpose ones.

I don't think the numbers reported in events should be forced to be
directly associated with the numbers (consider the case with mixes of
high sensitivity and low sensitivity inputs for example).

> >> Not hard wired so to my mind these are just general purpose temperature inputs.
> >> Hence naming doesn't make sense (at least not outside of board file or DT).

> > No, they're hard wired - like I say they're wired to a particular place.

> If it isn't physically in the pmic package then it doesn't belong in the driver.

In the case of the die temperature measurement things are obviously
entirely within the PMIC.  In the case of battery temperature monitoring
the actual sensor is outside the device but it's fixed function due to
cross connection with the autonomous control logic for the battery
chargers.

> Note the numbering is still going to be Linux specific just within a given type
> of channel. ADC channels regularly have completely inconsistent (and/or stupid) names
> in device data sheets.

> 0...4
> 1...5
> AUXA....AUXD
> TEMP_EXT1...TEMP_EXT5 (all of which are just normal adc channels that some
> designer decided would be used only for connecting analog temperature sensors.)

None of those look at all unreasonable?

> All of these get mapped to 0...4.  Anything else leads to totally unpredictable
> guessing games when trying to find the channel.

I dunno, things like introducing an offset of 1 into the numbers the
datasheet uses can be pretty painful to work with - it's not obvious
when looking at the code that you've got the number wrong.  With the
PMICs it's been really helpful to do things like map the LDOs and DCDCs
separately even though at the level where you're gluing things together
there's no meaningful difference.

Once we're running it's a different story, it's just when expressing the
wiring to the system that I'm worried.
