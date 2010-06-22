Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab0FVJmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:42:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50222 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173Ab0FVJl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=FsS5y4lX3H2EQTsNSsIoQ0mUJH3KpEZ9fgBD5MmtOAviht+P/GXkgjadoXgQpaRiSc
         5tnEE30jTPFXqC/hLgUu7Xsgogw13aXaDgLKCD+9mjS+r7SG2olJNtukmEcgW3PtldN3
         YsClNrF76aPx/LExfTxU+2m0roSKl/UzfJbbE=
MIME-Version: 1.0
In-Reply-To: <4C207DAF.7010200@gmail.com>
References: <4C207DAF.7010200@gmail.com>
Date: Tue, 22 Jun 2010 17:41:57 +0800
Message-ID: <AANLkTinJplJTzj9rqfmpS0ZXwXDTATuNoxgMjL1z5tEv@mail.gmail.com>
Subject: Re: [PATCH] RTC/max6900: use rtc_valid_tm to check returning tm for 
	max6900
From: Wan ZongShun <mcuos.com@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       rtc-linux <rtc-linux@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>, dale@farnsworth.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

> Use rtc_valid_tm to check returning tm for max6900,
> it can avoid returning wrong tm value.
> ---
>  drivers/rtc/rtc-max6900.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
> index a4f6665..486142c 100644
> --- a/drivers/rtc/rtc-max6900.c
> +++ b/drivers/rtc/rtc-max6900.c
> @@ -159,7 +159,7 @@ static int max6900_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
>                      bcd2bin(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
>        tm->tm_wday = bcd2bin(regs[MAX6900_REG_DW]);
>
> -       return 0;
> +       return rtc_valid_tm(tm);
>  }
>
>  static int max6900_i2c_clear_write_protect(struct i2c_client *client)
> --
> 1.6.3.3
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
