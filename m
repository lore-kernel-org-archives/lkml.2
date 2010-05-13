Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0EMHxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:53:42 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47130 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0EMHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uloU77yxidg3Qn0HRsPZdBsx2fxFQtYLqUdZmHby4nAYGgD81PQVboY+TvpxorT1gy
         OUXzXsIB7/r9HZa8DcYq2Qv8NT5JGmtxnZ7bUjwKpg8PaSpCkNw+5OWvST4DZjPrvcqD
         3eiIEe0C+AAxDK6O4Jc6kyBjF/mMj4C1RYY+g=
Date: Thu, 13 May 2010 00:53:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
Message-ID: <20100513075335.GD30110@core.coreip.homeip.net>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
 <n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com>
 <4BE3E02E.1090500@emlix.com>
 <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 02:23:07PM -0400, Mike Frysinger wrote:
> On Fri, May 7, 2010 at 05:41, Daniel Glöckner wrote:
> > On 05/06/2010 08:26 PM, Mike Frysinger wrote:
> >> i think it'd be a better idea to do something like:
> >>   if (spi->bits_per_word != 16) {
> >>     if (spi->bits_per_word) {
> >>       dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
> >>       return -EINVAL;
> >>     }
> >>     spi->bits_per_word = 16;
> >>     spi_setup(spi);
> >>   }
> >
> > There is no way to set bits_per_word using struct spi_board_info. The
> > description of that structure in spi.h explicitly lists the wordsize as
> > one of the parameters drivers should set themself in probe().
> >
> > Only struct bfin5xx_spi_chip allows to set this value in the board code.
> 
> an obvious shortcoming in the SPI framework that should be fixed, but
> that doesnt make any difference to the above code now does it ?  it'll
> operate correctly regardless of the SPI bus master.

So is the updated patch coming?

-- 
Dmitry
