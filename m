Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0LWOiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:38:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58436 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab0LWOiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DD/c8NijHnH740kaX8q1G3exs33c91jzLmYAUNSAOAI6FeosTjc6+fo7pDck78i8YF
         UPWQrae61IIbCQRv6q8mmqfi1XV8dM/l3AKSyHsHpZ0tebiGM7Hq8lE8JEGV01nk9JtR
         S6vZjWW4Ajmgt3ogl1EuUk1mvDjSbSBxVPTUY=
MIME-Version: 1.0
In-Reply-To: <20101223142934.GU14221@pengutronix.de>
References: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com>
 <1293102730-32528-2-git-send-email-richard.genoud@gmail.com> <20101223142934.GU14221@pengutronix.de>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 23 Dec 2010 15:38:04 +0100
Message-ID: <AANLkTik_DBHe0fGGuzwtDP7XFqcmuVuADmL3b+5no0Bm@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi_imx.c: TRIVIAL mx25 & mx35 SPI_VER is 0.7
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Thu, Dec 23, 2010 at 12:12:10PM +0100, Richard Genoud wrote:
>> The check on cpu_is_mx25 and cpu_is_mx35 was made twice.
>> This is obviously wrong.
> obviously wrong but no wrong behaviour.  Your patch only makes the code
> consistent, but IMHO it doesn't qualify as a bugfix.
yes, that's what I said, this patch doesn't change the behaviour, it's
only janitoring (I could have CC the list by the way).

If the whole SPI_IMX_VER_AUTODETECT system is going to be trashed,
sure, my patch is useless...

>
>> Anyway, this patch won't change the previous behaviour which is
>> SPI_IMX_VER_0_7 for mx25 and mx35.
> This conflicts with
> http://mid.gmane.org/1290589546-21662-1-git-send-email-u.kleine-koenig@pengutronix.de
>
> which I prefer.  The platform IDs have it correct (i.e.
>
>        imx25-cspi -> 0.7
>        imx31-cspi -> 0.4
>        imx35-cspi -> 0.7
>
> )
>
> Best regards
> Uwe
>
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>  drivers/spi/spi_imx.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
>> index 793ae99..96be9d1 100644
>> --- a/drivers/spi/spi_imx.c
>> +++ b/drivers/spi/spi_imx.c
>> @@ -806,7 +806,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
>>               if (cpu_is_mx25() || cpu_is_mx35())
>>                       spi_imx->devtype_data =
>>                               spi_imx_devtype_data[SPI_IMX_VER_0_7];
>> -             else if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35())
>> +             else if (cpu_is_mx31())
>>                       spi_imx->devtype_data =
>>                               spi_imx_devtype_data[SPI_IMX_VER_0_4];
>>               else if (cpu_is_mx27() || cpu_is_mx21())
>> --
>> 1.7.1
>>

Richard.
