Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab2HVJBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:01:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56286 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab2HVJBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:01:00 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Chinmay V S <cvs268@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Topic: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Index: AQHNgC+0NDpTyonaHU+HVTncuJ8wyZdlGIEAgAAPuoCAAFzA0A==
Date: Wed, 22 Aug 2012 09:00:40 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de>
 <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
In-Reply-To: <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7M91BCf024004

Hi Chinmay,

Thanks for the comments

On Wed, Aug 22, 2012 at 14:14:55, Chinmay V S wrote:
> Hi All,
> 
> A few nitpicks.
> 
> > + * LIS3331DLH spec says 1LSBs corresponds 4G/1024 -> 1LSB is 1000/1024 mG.
> > + * Sensitivity values for +/-2G, outdata in 12 bits for +/-2G scale. so 4
> > + * bits adjustment is required
> Shouldn't it be "1LSB is 4000/1024 mG" ?

Typo mistake this should be 4G/4096

> Also "outdata in 12bits" (typo. in->is?)
> 

If we look at the lis331dlh datasheet 12 bits outdata for +/- 2G resolution
range and 13 bits for +/- 4G range and 14 bits for +/- 8G range. So output
data is only 12 bits.

> On a more technical note, now that LIS3331DLH has 16bit resolution,
> why don't we simply return the entire 16-bit value in
> lis3lv02d_read_16(). The fact that lis3lv02d_read_16() has 16-bit
> resolution can be indicated by

Depending on the range 2 or 4 or 8 we have to pass the outdata that is
handled by using the shift_adj member to shift the outdata to corresponding
bits 12/13/14.

> 
> @@ -954,6 +984,16 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
>                 lis3->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
>                 lis3->scale = LIS3_SENSITIVITY_8B;
>                 break;
> +       case WAI_3DLH:
> +               pr_info("16 bits 3DLH sensor found\n");
> +               lis3->read_data = lis3lv02d_read_16;
> +               lis3->mdps_max_val = 32768; /* 16 bits for +/-2G */

This driver supports only +/-2G range of values so it is limited to 2048.
With this we do not have the runtime change of G range so by default 2G
is added.

Regards
AnilKumar
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
