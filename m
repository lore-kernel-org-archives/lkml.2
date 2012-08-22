Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2HVPWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab2HVPWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:22:01 -0400
Message-ID: <5034F932.4000405@redhat.com>
Date: Wed, 22 Aug 2012 17:22:26 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/radio/shark2: Fix build error caused by missing
 dependencies
References: <1345648585-5176-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1345648585-5176-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've a better fix for this here:
http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.6

I already send a pull-req for this to Mauro a while ago, Mauro?

Regards,

Hans

On 08/22/2012 05:16 PM, Guenter Roeck wrote:
> Fix build error:
>
> ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
> ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!
>
> which is seen if RADIO_SHARK2 is enabled, but LEDS_CLASS is not.
>
> Since RADIO_SHARK2 depends on NEW_LEDS and LEDS_CLASS, select both if
> it is enabled.
>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   drivers/media/radio/Kconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 8090b87..bee4bee 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -77,6 +77,8 @@ config RADIO_SHARK
>   config RADIO_SHARK2
>   	tristate "Griffin radioSHARK2 USB radio receiver"
>   	depends on USB
> +	select NEW_LEDS
> +	select LEDS_CLASS
>   	---help---
>   	  Choose Y here if you have this radio receiver.
>
>
