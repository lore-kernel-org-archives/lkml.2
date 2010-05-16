Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0EPTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 15:25:56 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:56142 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0EPTZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 15:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wFSGcby/J/hFEzRqgOcGtYWUH4xs2XZS3ORptHTecOe43zqZFd0fbmhctcHHCoDT+e
         prSEmXJ7O14NBZM12G7wwbpOXK2NJGNyedgEMxt9fCsPlUmj1jYGXFrpwUPoJsCfIjWZ
         tVhLqeMxz5kWSkV11puqn5Jm1Ahc1TSn2wL6Q=
MIME-Version: 1.0
In-Reply-To: <20100515181523.GA3081@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> 
	<n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com> 
	<4BE3E02E.1090500@emlix.com> <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com> 
	<20100513075335.GD30110@core.coreip.homeip.net> <20100515181523.GA3081@emlix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 16 May 2010 15:25:34 -0400
Message-ID: <AANLkTinn6VgvujPP3gGsteBGckIFgljn7B35DV6n8kwL@mail.gmail.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
To: Oskar Schirmer <os@emlix.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 14:15, Oskar Schirmer wrote:
> On Thu, May 13, 2010 at 00:53:35 -0700, Dmitry Torokhov wrote:
>> On Fri, May 07, 2010 at 02:23:07PM -0400, Mike Frysinger wrote:
>> > On Fri, May 7, 2010 at 05:41, Daniel Glöckner wrote:
>> > > On 05/06/2010 08:26 PM, Mike Frysinger wrote:
>> > >> i think it'd be a better idea to do something like:
>> > >>   if (spi->bits_per_word != 16) {
>> > >>     if (spi->bits_per_word) {
>> > >>       dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
>> > >>       return -EINVAL;
>> > >>     }
>> > >>     spi->bits_per_word = 16;
>> > >>     spi_setup(spi);
>> > >>   }
>> > >
>> > > There is no way to set bits_per_word using struct spi_board_info. The
>> > > description of that structure in spi.h explicitly lists the wordsize as
>> > > one of the parameters drivers should set themself in probe().
>> > >
>> > > Only struct bfin5xx_spi_chip allows to set this value in the board code.
>> >
>> > an obvious shortcoming in the SPI framework that should be fixed, but
>> > that doesnt make any difference to the above code now does it ?  it'll
>> > operate correctly regardless of the SPI bus master.
>>
>> So is the updated patch coming?
>
> The basic question I see is, whether it is in the
> responsibility of ad7877 to check a wrong setting
> possibly caused in board specific code. If so,
> then the proposal by Mike should be used, but if not
> so, it would introduce unneeded code.
>
> Remember: both versions end up in correctly setting
> bits_per_word, with the difference merely in feedback
> level.

imo, unsupported board settings should always be detected & rejected.
all SPI master drivers do this (detect & reject unsupported SPI slave
settings).
-mike
