Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0EGSXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:23:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53874 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab0EGSXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lFRe/QUu+MXVfNpSFqKV6AcaTSQeWkfpzFtM7bRBQIt7KFR13rO40L4AkK1o0A+RU1
         Qr6kmuFzuZ35n7BOEYI5qSGkKt8jApNn0QCELXUHmAsnZD8sFDg+f4MaNhnREbDgRrFb
         ZATThPVubmHqlLGT3891AsBnUDJpefgUqx/FU=
MIME-Version: 1.0
In-Reply-To: <4BE3E02E.1090500@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> 
	<n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com> 
	<4BE3E02E.1090500@emlix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 7 May 2010 14:23:07 -0400
Message-ID: <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
To: =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 05:41, Daniel Glöckner wrote:
> On 05/06/2010 08:26 PM, Mike Frysinger wrote:
>> i think it'd be a better idea to do something like:
>>   if (spi->bits_per_word != 16) {
>>     if (spi->bits_per_word) {
>>       dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
>>       return -EINVAL;
>>     }
>>     spi->bits_per_word = 16;
>>     spi_setup(spi);
>>   }
>
> There is no way to set bits_per_word using struct spi_board_info. The
> description of that structure in spi.h explicitly lists the wordsize as
> one of the parameters drivers should set themself in probe().
>
> Only struct bfin5xx_spi_chip allows to set this value in the board code.

an obvious shortcoming in the SPI framework that should be fixed, but
that doesnt make any difference to the above code now does it ?  it'll
operate correctly regardless of the SPI bus master.
-mike
