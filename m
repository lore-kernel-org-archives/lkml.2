Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0ELUy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:54:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36789 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0ELUy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:54:26 -0400
X-IronPort-AV: E=Sophos;i="4.53,217,1272859200"; 
   d="scan'208";a="16561047"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 21:54:21 +0100
Subject: RE: [PATCH -mmotm] backlight: fix adp8860_bl build errors
Thread-Topic: [PATCH -mmotm] backlight: fix adp8860_bl build errors
Thread-Index: AcryE0l+CgyHicOZQmmiitfpQy/u9wAAfilg
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E568FBD9F@LIMKCMBX1.ad.analog.com>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
 <20100512133919.016d6286.randy.dunlap@oracle.com>
In-Reply-To: <20100512133919.016d6286.randy.dunlap@oracle.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote on 2010-05-12:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add slab.h to fix part of build. Add a parameter in
> backlight_device_register() call to fix part of build.
>
> drivers/video/backlight/adp8860_bl.c:215: error: implicit declaration
> of function 'kzalloc'
> drivers/video/backlight/adp8860_bl.c:215: warning: assignment makes
> pointer from integer without a cast
> drivers/video/backlight/adp8860_bl.c:285: error: implicit declaration
> of function 'kfree'
> drivers/video/backlight/adp8860_bl.c:673: warning: assignment makes
> pointer from integer without a cast
> drivers/video/backlight/adp8860_bl.c:689: error: too few arguments to
> function 'backlight_device_register'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Michael Hennerich <michael.hennerich@analog.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

Thanks!

> ---
>  drivers/video/backlight/adp8860_bl.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> --- mmotm-2010-0511-1820.orig/drivers/video/backlight/adp8860_bl.c
> +++ mmotm-2010-0511-1820/drivers/video/backlight/adp8860_bl.c
> @@ -16,6 +16,7 @@
>  #include <linux/fb.h> #include <linux/backlight.h> #include
>  <linux/leds.h> +#include <linux/slab.h> #include <linux/workqueue.h>
>
>  #include <linux/i2c/adp8860.h> @@ -647,6 +648,7 @@ static int __devinit
>  adp8860_probe(struc  struct adp8860_bl *data;        struct
>  adp8860_backlight_platform_data *pdata =             client->dev.platform_data;
>  +    struct backlight_properties props;      uint8_t reg_val;        int ret;
> @@ -683,10 +685,13 @@ static int __devinit adp8860_probe(struc
>       data->current_brightness = 0;
>       i2c_set_clientdata(client, data);
> +     memset(&props, 0, sizeof(props));
> +     props.max_brightness = ADP8860_MAX_BRIGHTNESS;
> +
>       mutex_init(&data->lock);
>
>       bl = backlight_device_register(dev_driver_string(&client->dev),
> -                     &client->dev, data, &adp8860_bl_ops);
> +                     &client->dev, data, &adp8860_bl_ops, &props);
>       if (IS_ERR(bl)) {
>               dev_err(&client->dev, "failed to register backlight\n");
>               ret = PTR_ERR(bl);

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


