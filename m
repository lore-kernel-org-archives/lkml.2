Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0EOSPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:15:32 -0400
Received: from mx1.emlix.com ([193.175.82.87]:60388 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0EOSPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:15:30 -0400
Date: Sat, 15 May 2010 20:15:24 +0200
From: Oskar Schirmer <os@emlix.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
Message-ID: <20100515181523.GA3081@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> <n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com> <4BE3E02E.1090500@emlix.com> <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com> <20100513075335.GD30110@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100513075335.GD30110@core.coreip.homeip.net>
Organization: emlix GmbH
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 00:53:35 -0700, Dmitry Torokhov wrote:
> On Fri, May 07, 2010 at 02:23:07PM -0400, Mike Frysinger wrote:
> > On Fri, May 7, 2010 at 05:41, Daniel Glöckner wrote:
> > > On 05/06/2010 08:26 PM, Mike Frysinger wrote:
> > >> i think it'd be a better idea to do something like:
> > >>   if (spi->bits_per_word != 16) {
> > >>     if (spi->bits_per_word) {
> > >>       dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
> > >>       return -EINVAL;
> > >>     }
> > >>     spi->bits_per_word = 16;
> > >>     spi_setup(spi);
> > >>   }
> > >
> > > There is no way to set bits_per_word using struct spi_board_info. The
> > > description of that structure in spi.h explicitly lists the wordsize as
> > > one of the parameters drivers should set themself in probe().
> > >
> > > Only struct bfin5xx_spi_chip allows to set this value in the board code.
> > 
> > an obvious shortcoming in the SPI framework that should be fixed, but
> > that doesnt make any difference to the above code now does it ?  it'll
> > operate correctly regardless of the SPI bus master.
> 
> So is the updated patch coming?

The basic question I see is, whether it is in the
responsibility of ad7877 to check a wrong setting
possibly caused in board specific code. If so,
then the proposal by Mike should be used, but if not
so, it would introduce unneeded code.

Remember: both versions end up in correctly setting
bits_per_word, with the difference merely in feedback
level.

This is a design decision, I'ld say. So what are the
opinions on it, has it been taken yet, previously?

  Oskar
-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160
geschäftsführer: dr. uwe kracke, ust-idnr.: de 205 198 055

emlix - your embedded linux partner
