Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab2K2Fa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:30:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16340 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2K2Fa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:30:57 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-8e-50b6f30f7ecf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marko Katic'" <dromede@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1354139201-12834-1-git-send-email-dromede@gmail.com>
In-reply-to: <1354139201-12834-1-git-send-email-dromede@gmail.com>
Subject: Re: [PATCH] backlight: corgi_lcd: Fix WARN_ON() when calling
 corgi_bl_set_intensity.
Date: Thu, 29 Nov 2012 14:30:54 +0900
Message-id: <001501cdcdf2$b3f8f730$1beae590$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3NsjRdKq6MS8s8QXCuNQ95z6swcgAOdhhA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zfV3+z9sCDG7e5LQ40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUc/N3CVHCLv+LBCdcGxg7eLkZODgkBE4kHf6cwQthi
	EhfurWfrYuTiEBJYxihx+m03SxcjB1jRmwfGEPFFjBITj+9ghHB+MUpsPPGRGaSbTUBN4suX
	w+wgtoiAqsSu/7fAJjELfGWU2Hm6lxFkkpCAo8SBg8UgNZwCThL7n39jBbGFBeIlHl7fzgRi
	swD1zlx5FGwOr4CtxMEl09kgbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxqLrEo7+6ECcY
	Scy+eo8RokREYt+Ld4wQ4wUkvk0+BPWXrMSmA8wgV0oIrGKXWNZ/FRoQkhIHV9xgmcAoMQvJ
	5llINs9CsnkWkhULGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYoREmNQOxpUNFocYBTgY
	lXh4N1luCxBiTSwrrsw9xCjBwawkwmtZDRTiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGD0
	55XEGxobm5iZmJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAuNGqqUTJSvmj
	z8F9oZdLnPccZTT3+i05bXmcpI5x7OLF27eKzo8zyku4ksPBsJptnajTuvOBXK80PnM2nvlk
	8lt+r9T7QM29/Hen7P7GrqvUErp2WrmQVCAP97W3wgelf69wdWFgS9jw4N2BQ4sm7P50X+i+
	2Ydne1svPpUR2+TEonWKddLOZCWW4oxEQy3mouJEAAGqXbPdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAV3+z9sCDGZ8Y7U40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHPzdwlRwi7/i
	wQnXBsYO3i5GDg4JAROJNw+Muxg5gUwxiQv31rN1MXJxCAksYpSYeHwHI4Tzi1Fi44mPzCBV
	bAJqEl++HGYHsUUEVCV2/b8F1sEs8JVRYufpXkaQqUICjhIHDhaD1HAKOEnsf/6NFcQWFoiX
	eHh9OxOIzQLUO3PlUbA5vAK2EgeXTGeDsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPE0eoS
	j/7qQpxgJDH76j1GiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwfH7TGoH48oGi0OMAhyMSjy8myy3BQixJpYVV+YeYpTgYFYS4bWsBgrx
	piRWVqUW5ccXleakFh9i9AF6dCKzlGhyPjC15JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRAS
	SE8sSc1OTS1ILYIZx8TBKdXAmCC4dEL4rTkfVp+IDBb/dGiKdF2bUGzF60f3uq+E+4m5bwiU
	+tq6cPbxN9N49nJ11MhP7RT9klOwMXAmz4dF9+NWTszSio7o5D/K/TkwRLmIRVVif5+wg3rt
	S+2N3Gen89SH/ry//26GxBcJ1+oUp3dTaj5pfGhltlqV17jdYPp1CzufBU90lViKMxINtZiL
	ihMBLZJ7nAwDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 29, 2012 6:47 AM, Marko Katic wrote
> Subject: [PATCH] backlight: corgi_lcd: Fix WARN_ON() when calling corgi_bl_set_intensity.

CC'ed Andrew Morton.


Hi Marko Katic,
The commit subject and commit message are not clear.

How about using subject as below?
backlight: corgi_lcd: use gpio_set_value_cansleep()

In addition, 'Fix WARN_ON() when calling corgi_bl_set_intensity'
would be the reason why you submit this patch.
Please make the commit message more detail.

Also, I have a question on gpio driver.
In order to trigger WARN_ON(chip->can_sleep), 'can_sleep' should be
set as 1. However, I cannot find 'can_sleep = 1' in the PXA gpio driver.
What gpio driver do you use to test corgi_lcd driver?


Best regards,
Jingoo Han

> 
> From: Marko Katic <dromede.gmail.com>
> 
> 
> Signed-off-by: Marko Katic <dromede@gmail.com>
> ---
>  drivers/video/backlight/corgi_lcd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
> index c781768..8b002d7 100644
> --- a/drivers/video/backlight/corgi_lcd.c
> +++ b/drivers/video/backlight/corgi_lcd.c
> @@ -409,10 +409,10 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
>  	cont = !!(intensity & 0x20) ^ lcd->gpio_backlight_cont_inverted;
> 
>  	if (gpio_is_valid(lcd->gpio_backlight_cont))
> -		gpio_set_value(lcd->gpio_backlight_cont, cont);
> +		gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
> 
>  	if (gpio_is_valid(lcd->gpio_backlight_on))
> -		gpio_set_value(lcd->gpio_backlight_on, intensity);
> +		gpio_set_value_cansleep(lcd->gpio_backlight_on, intensity);
> 
>  	if (lcd->kick_battery)
>  		lcd->kick_battery();
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

