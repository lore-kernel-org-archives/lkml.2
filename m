Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2JRXD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:03:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56202 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2JRXD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:03:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Topic: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Index: Ac2s93gDQSeJyP+TRoq5NeyBztAjJf//0CQA//63kgA=
Date: Thu, 18 Oct 2012 23:03:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641790DF@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F64178FA7@DQHE02.ent.ti.com>
 <507FE604.8070404@metafoo.de>
In-Reply-To: <507FE604.8070404@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Thursday, October 18, 2012 8:21 PM
> To: Kim, Milo
> Cc: cbou@mail.ru; Anton Vorontsov; Jonathan Cameron; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
 
> >
> > +	ret = iio_read_channel_raw(channel, &raw);
> > +	if (ret != IIO_VAL_INT)
> > +		return -EINVAL;
> > +
> >  	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
> >  	if (ret != IIO_VAL_INT_PLUS_MICRO)
> >  		return -EINVAL;
> >
> >  	/* unit: mV */
> > -	*result = (scaleint + scalepart * 1000000) / 1000;
> > +	tmp = raw * scaleint + div_u64(raw * scalepart, 1000000L);
> > +	*result = (unsigned int)tmp;
> 
> 
> We now have a function in the IIO core which does the sampling +
> conversion
> in one step: iio_read_channel_processed. This basically allows you to
> reduce
> this function to
> 
> 	return iio_read_channel_processed(channel, result);

I was hesitating it before sending this patch. :)
Currently, LP8788 ADC driver has no iio channel info for PROCESSED.
Thus, I'll add it in the LP8788 ADC driver first.
Then I'll send the patch for lp8788-charger again.

Thanks for your comment!

Best Regards,
Milo
