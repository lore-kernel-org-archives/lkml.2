Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0EGJlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:41:11 -0400
Received: from mx1.emlix.com ([193.175.82.87]:47907 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab0EGJlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:41:08 -0400
Message-ID: <4BE3E02E.1090500@emlix.com>
Date: Fri, 07 May 2010 11:41:02 +0200
From: =?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
References: <1273142265-11929-1-git-send-email-os@emlix.com> <n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com>
In-Reply-To: <n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 08:26 PM, Mike Frysinger wrote:
> i think it'd be a better idea to do something like:
>   if (spi->bits_per_word != 16) {
>     if (spi->bits_per_word) {
>       dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
>       return -EINVAL;
>     }
>     spi->bits_per_word = 16;
>     spi_setup(spi);
>   }

There is no way to set bits_per_word using struct spi_board_info. The
description of that structure in spi.h explicitly lists the wordsize as
one of the parameters drivers should set themself in probe().

Only struct bfin5xx_spi_chip allows to set this value in the board code.

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
