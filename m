Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0GNGyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:54:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56523 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0GNGyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cVzOBEaaWuPCU98+8PpdNMEJCMCcFrCSlM8Cx5KV7AZQIkK2t6rw/Qx+tOIG2ha60q
         DmpMiP2U+9UZ+SfyYzhRSpFSJFoeiqIXBvGzltz+Ar/QtPqiA6yiyZy7G8VqN/o1fL5W
         isdyGPq539lRoRzSRneTP1NFi3VdQvxcMUyLU=
MIME-Version: 1.0
In-Reply-To: <201007140742.58766.roman.fietze@telemotive.de>
References: <201006171123.31484.roman.fietze@telemotive.de>
	<AANLkTikvYWFRthn5gyppxYExKs8C-5FC-7ybnqO_sWTk@mail.gmail.com>
	<201006180727.06274.roman.fietze@telemotive.de>
	<201007140742.58766.roman.fietze@telemotive.de>
Date: Wed, 14 Jul 2010 14:54:39 +0800
Message-ID: <AANLkTilkyIHdtwSAgbp2sr84PRblmiGwRw8NxglKnJa7@mail.gmail.com>
Subject: Re: [PATCH] rtc-isl12022: properly handle military hour format
From: Wan ZongShun <mcuos.com@gmail.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Roman Fietze <roman.fietze@telemotive.de>:
> Hello Wan, hello list members,
>
> I found a bug in my rtc-isl12022. Seems I missed to test that driver
> thoroughly in the afternoons.

It's not very helpful to only say "I found a bug in ". What was wrong
with the old code missed some flags?
But I give you my ack, since I believe it is really wrong, you should
know more this hardware register than me.:)

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

>
> From 151b7d5413e189ec8f6dd578c253500d8814128e Mon Sep 17 00:00:00 2001
> From: Roman Fietze <roman.fietze@telemotive.de>
> Date: Wed, 14 Jul 2010 07:32:49 +0200
> Subject: [PATCH] rtc-isl12022: properly handle military hour format
>
> Mask out PM flag when reading the hour, always set MIL bit when
> writing the hour.
>
> Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
> ---
>  drivers/rtc/rtc-isl12022.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
> index 293d2c1..0f300b4 100644
> --- a/drivers/rtc/rtc-isl12022.c
> +++ b/drivers/rtc/rtc-isl12022.c
> @@ -126,7 +126,7 @@ static int isl12022_get_datetime(struct i2c_client
> *client, struct rtc_time *tm)
>
>        tm->tm_sec = bcd2bin(buf[ISL12022_REG_SC] & 0x7F);
>        tm->tm_min = bcd2bin(buf[ISL12022_REG_MN] & 0x7F);
> -       tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x3F);
> +       tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x1F);
>        tm->tm_mday = bcd2bin(buf[ISL12022_REG_DT] & 0x3F);
>        tm->tm_wday = buf[ISL12022_REG_DW] & 0x07;
>        tm->tm_mon = bcd2bin(buf[ISL12022_REG_MO] & 0x1F) - 1;
> @@ -192,7 +192,7 @@ static int isl12022_set_datetime(struct i2c_client
> *client, struct rtc_time *tm)
>        /* hours, minutes and seconds */
>        buf[ISL12022_REG_SC] = bin2bcd(tm->tm_sec);
>        buf[ISL12022_REG_MN] = bin2bcd(tm->tm_min);
> -       buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour);
> +       buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour) | ISL12022_HR_MIL;
>
>        buf[ISL12022_REG_DT] = bin2bcd(tm->tm_mday);
>
> --
> 1.7.1
>
>
> --
> Roman Fietze              Telemotive AG Buero Muehlhausen
> Breitwiesen                             73347 Muehlhausen
> Tel.: +49(0)7335/18493-45        http://www.telemotive.de
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
