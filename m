Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0JEVhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:37:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11579 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab0JEVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:37:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 05 Oct 2010 14:37:11 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Joe Perches <joe@perches.com>
CC: "jic23@cam.ac.uk" <jic23@cam.ac.uk>, Andrew Chew <AChew@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Tue, 5 Oct 2010 14:36:41 -0700
Subject: RE: [PATCH v2] iio: light: Adding driver for ISL29018 ALS
Thread-Topic: [PATCH v2] iio: light: Adding driver for ISL29018 ALS
Thread-Index: Actk1TbgBQoMMIrGT46mYN45Bm55VwAABCzg
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D2D2620A@HQMAIL01.nvidia.com>
References: <1286313561-6456-1-git-send-email-rklein@nvidia.com>
 <1286314517.2156.50.camel@Joe-Laptop>
In-Reply-To: <1286314517.2156.50.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o95LbUXo020535

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, October 05, 2010 2:35 PM
> To: Rhyland Klein
> Cc: jic23@cam.ac.uk; Andrew Chew; olof@lixom.net; linux-
> i2c@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> iio@vger.kernel.org; Laxman Dewangan
> Subject: Re: [PATCH v2] iio: light: Adding driver for ISL29018 ALS
> 
> On Tue, 2010-10-05 at 14:19 -0700, rklein@nvidia.com wrote:
> > Adding support for the ISL 29018 ambient light and proximity sensor.
> 
> Trivial comments below.
> 
> > diff --git a/drivers/staging/iio/light/isl29018.c
> b/drivers/staging/iio/light/isl29018.c
> []
> > +static int isl29018_set_range(struct i2c_client *client, unsigned long
> range,
> > +		unsigned int *new_range)
> > +{
> > +	unsigned long supp_ranges[] = {1000, 4000, 16000, 64000};
> 
> static const

Will change.

> 
> > +static int isl29018_set_resolution(struct i2c_client *client,
> > +			unsigned long adcbit, unsigned int *conf_adc_bit)
> > +{
> > +	unsigned long supp_adcbit[] = {16, 12, 8, 4};
> 
> here too

This too.

> 
> > +static int isl29018_chip_init(struct i2c_client *client)
> > +{
> > +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> > +	int status;
> > +	int i;
> > +	int new_adc_bit;
> > +	unsigned int new_range;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(chip->reg_cache); i++)
> > +		chip->reg_cache[i] = 0;
> 
> memset?
> 

I could use memset, except this is only 4 registers = 32 bytes, so I don't think that is really worth it do you?

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
