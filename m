Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1AaQD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:03:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61566 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1AaQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xSYjdh/T1QDNCQmuPPFP9aboegvwmfB7Z8uUhhSeBAGX7PDvZR8g4MsnI0kHPyvOrc
         XTr3srwOyVqk4bPuELu0u8likpg7dXa2yftfrJg5bQjf7hvaHV1qfeoizL/D8DCkTgGb
         dYHUV+uW6UXHI9aCiK3Mk5+WSYA7A4SfqDeug=
Date: Mon, 31 Jan 2011 19:03:21 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
Message-ID: <20110131160321.GA23546@oksana.dev.rtsoft.ru>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru>
 <20110131154354.GC3819@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110131154354.GC3819@enneenne.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:43:56PM +0100, Rodolfo Giometti wrote:
> On Mon, Jan 31, 2011 at 04:51:47PM +0300, Anton Vorontsov wrote:
[...]
> Why not using:
> 
>    !!(gpio & 0x40)
> 
> or
> 
>    (gpio & 0x40) ? 1 : 0
> 
> ? I think it could be more readable... :)
> 
> However, I don't understand why you fix gpio=0... it's your machine
> depending settings? In these case you should use the platform_data
> mechanism to properly setup the GPIO.

I agree. It looks like a machine-specific configuration, and
exporting this GPIO as 'ONLINE' property may break other users.

Instead, I would suggest adding gpiolib support into this driver,
and passing 'int online_gpio' via platform data. That way you can
pass any GPIOs to this driver, not only bq's.

Pali, you can just split GPIO and 'ONLINE' property additions
into a separate patch for now, so we can apply the rest of the
changes, and hold on the GPIO stuff.

[...]
> > +static int bq27x00_battery_nac(struct bq27x00_device_info *di)
> 
> Let me suggest using bq27x00_battery_nac_uAh as function name...

Regarding these suffixes. I'm not sure. This seems a bit too
verbose. So I'd prefer to not introduce these.

Though, whatever you guys like... I'm fine either way.

[...]
> >  MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
> >  MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
> > +MODULE_ALIAS("i2c:bq27000");
> > +MODULE_ALIAS("i2c:bq27200");
> > +MODULE_ALIAS("i2c:bq27500");

Btw, this is actually another bugfix. Pali, you might want to separate
it into yet another patch.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
