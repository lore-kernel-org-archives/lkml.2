Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0F1E4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 00:56:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35272 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0F1E4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 00:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=W1/rBxw8ucj4v63QwtoHMD+7sWIw67CQS+44r8YFVwOHLXHBaqCDbBRMvi4TylFsj/
         Kz/VoY+0ntnbrsFblciX6WyOpQymbnJj5tt90qH9RSuprtNJMPVdRZZddkFkxiopIlQE
         5CFG03Xzw4mNGKu3jMLVcfVPFFs76j/9Haqq4=
MIME-Version: 1.0
In-Reply-To: <20100622052314.GA17128@pengutronix.de>
References: <20100618073950.GA12822@pengutronix.de> <1277129511-2732-1-git-send-email-u.kleine-koenig@pengutronix.de> 
	<20100621213846.GB25511@kroah.com> <20100622052314.GA17128@pengutronix.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 28 Jun 2010 12:55:45 +0800
Message-ID: <AANLkTinMLrXyqKZ76AiWiw6N_glrWWrP-2_aUTzQm5Xr@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] Driver core: reduce duplicated code
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Dmitry Torokhov <dtor@mail.ru>, Anisse Astier <anisse@astier.eu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/22 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hi Greg,
>
>> > I changed the semantic slightly to only call
>> > platform_device_add_resources if data != NULL instead of size != 0.  The
>> > idea is to support wrappers like:
>> >
>> >     #define add_blablub(id, pdata) \
>> >             platform_device_register_resndata(NULL, "blablub", id, \
>> >                     NULL, 0, pdata, sizeof(struct blablub_platform_data))
>> >
>> > that don't fail if pdata=NULL.  Ditto for res.
>>
>> That's fine, but why would you want to have a #define for something like
>> this?  Is it really needed?
> Well, what is really needed?  I intend to use it on arm/imx.  I have
> several different machines using similar SoCs and so I want to have a
> function à la:
>
>        struct platform_device *__init imx_add_imx_i2c(int id,
>                resource_size_t iobase, resource_size_t iosize, int irq,
>                const struct imxi2c_platform_data *pdata)
>
> that builds a struct resource[] and then calls
> platform_device_register_resndata().  And then I have a set of macros
> like:
>
>        #define imx21_add_i2c_imx(pdata)        \
>                imx_add_imx_i2c(0, MX2x_I2C_BASE_ADDR, SZ_4K, MX2x_INT_I2C, pdata)
>        #define imx25_add_imx_i2c0(pdata)       \
>                imx_add_imx_i2c(0, MX25_I2C1_BASE_ADDR, SZ_16K, MX25_INT_I2C1, pdata)
>        ##define imx25_add_imx_i2c1(pdata)      \
>                imx_add_imx_i2c(1, MX25_I2C2_BASE_ADDR, SZ_16K, MX25_INT_I2C2, pdata)
>
> etc.  The final goal is to get rid of files like
> arch/arm/mach-mx3/devices.c.
>

Hi Uwe,

I suggest you to have a look into arch/arm/mach-mmp/devices.c and
arch/arm/mach-mmp/pxa{168,910}.c as well as
arch/arm/mach-mmp/include/mach/pxa{168,910}.h, maybe we can find
some common practice.

>> Anyway, this version looks fine to me, I'll go apply it.
> \o/
>
> Best regards and thanks
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
