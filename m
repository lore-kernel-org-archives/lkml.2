Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0EQH3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:29:43 -0400
Received: from mx1.emlix.com ([193.175.82.87]:52073 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0EQH3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:29:41 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Mon, 17 May 2010 09:29:36 +0200
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
Message-ID: <20100517072935.GA14891@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
 <n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com>
 <4BE3E02E.1090500@emlix.com>
 <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com>
 <20100513075335.GD30110@core.coreip.homeip.net>
 <20100515181523.GA3081@emlix.com>
 <AANLkTinn6VgvujPP3gGsteBGckIFgljn7B35DV6n8kwL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinn6VgvujPP3gGsteBGckIFgljn7B35DV6n8kwL@mail.gmail.com>
Organization: emlix GmbH
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 15:25:34 -0400, Mike Frysinger wrote:
> On Sat, May 15, 2010 at 14:15, Oskar Schirmer wrote:
> > On Thu, May 13, 2010 at 00:53:35 -0700, Dmitry Torokhov wrote:
> >> On Fri, May 07, 2010 at 02:23:07PM -0400, Mike Frysinger wrote:
> >> > On Fri, May 7, 2010 at 05:41, Daniel Glöckner wrote:
> >> > > On 05/06/2010 08:26 PM, Mike Frysinger wrote:
> >> > >> i think it'd be a better idea to do something like:
> >> > >>   if (spi->bits_per_word != 16) {
> >> > >>     if (spi->bits_per_word) {
> >> > >>       dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
> >> > >>       return -EINVAL;
> >> > >>     }
> >> > >>     spi->bits_per_word = 16;
> >> > >>     spi_setup(spi);
> >> > >>   }
> >> > >
> >> > > There is no way to set bits_per_word using struct spi_board_info. The
> >> > > description of that structure in spi.h explicitly lists the wordsize as
> >> > > one of the parameters drivers should set themself in probe().
> >> > >
> >> > > Only struct bfin5xx_spi_chip allows to set this value in the board code.
> >> >
> >> > an obvious shortcoming in the SPI framework that should be fixed, but
> >> > that doesnt make any difference to the above code now does it ?  it'll
> >> > operate correctly regardless of the SPI bus master.
> >>
> >> So is the updated patch coming?
> >
> > The basic question I see is, whether it is in the
> > responsibility of ad7877 to check a wrong setting
> > possibly caused in board specific code. If so,
> > then the proposal by Mike should be used, but if not
> > so, it would introduce unneeded code.
> >
> > Remember: both versions end up in correctly setting
> > bits_per_word, with the difference merely in feedback
> > level.
> 
> imo, unsupported board settings should always be detected & rejected.
> all SPI master drivers do this (detect & reject unsupported SPI slave
> settings).

please note, that bits_per_word is not a board setting,
it's a demand of the device. consequently, there is no one
to set unsupported values and thus none to be detected.

the only architecture setting bits_per_word thru spi_chip
is blackfin, but I cannot see a good reason, why the board
settings should engage with a fixed demand of the device?

  Oskar
-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160
geschäftsführer: dr. uwe kracke, ust-idnr.: de 205 198 055

emlix - your embedded linux partner
