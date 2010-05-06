Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab0EFLSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:18:42 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:61509 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab0EFLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:18:40 -0400
X-IronPort-AV: E=Sophos;i="4.52,340,1270440000"; 
   d="scan'208";a="16298404"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       =?utf-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>
Date: Thu, 6 May 2010 12:18:35 +0100
Subject: RE: [PATCH] ad7877: fix spi word size to 16 bit
Thread-Topic: [PATCH] ad7877: fix spi word size to 16 bit
Thread-Index: AcrtC68NC8ptfpY4StKS1+5pQ44XwAAAgGcw
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E568A07DD@LIMKCMBX1.ad.analog.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
In-Reply-To: <1273142265-11929-1-git-send-email-os@emlix.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o46IcfaS001354

Oskar Schirmer wrote on 2010-05-06:
> With no word size given in the users platform data, a generic spi host
> controller driver will assume a default word size of eight bit. This
> causes transmission to be performed bytewise, which will fail on
> little endian machines for sure. Failure on big endian depends on
> usage of slave select to mark word boundaries.
>
> Anyway, ad7877 is specified to work with 16 bit per word, so
> unconditionally set the word size accordingly.
>
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> Signed-off-by: Daniel GlÃ¶ckner <dg@emlix.com>
> Signed-off-by: Oliver Schneidewind <osw@emlix.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/input/touchscreen/ad7877.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> diff --git a/drivers/input/touchscreen/ad7877.c
> b/drivers/input/touchscreen/ad7877.c index e019d53..92acd85 100644 ---
> a/drivers/input/touchscreen/ad7877.c +++
> b/drivers/input/touchscreen/ad7877.c @@ -669,6 +669,8 @@ static int
> __devinit ad7877_probe(struct spi_device *spi)
>               dev_dbg(&spi->dev, "SPI CLK %d Hz?\n",spi->max_speed_hz);
>               return -EINVAL;
>       }
> +     spi->bits_per_word = 16;
> +     spi_setup(spi);
>
>       ts = kzalloc(sizeof(struct ad7877), GFP_KERNEL);
>       input_dev = input_allocate_device();

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
