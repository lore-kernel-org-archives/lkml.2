Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab2INAdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 20:33:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54353 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab2INAdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 20:33:41 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5] iio: adc: add new lp8788 adc driver
Thread-Topic: [PATCH v5] iio: adc: add new lp8788 adc driver
Thread-Index: Ac2PKo1M4qOcrsVCSgiDBWHIlCmBdv//jESA//nIgSA=
Date: Fri, 14 Sep 2012 00:33:27 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF4BFC@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF45CC@DQHE02.ent.ti.com>
 <504DADE1.6010303@metafoo.de>
In-Reply-To: <504DADE1.6010303@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> One issue and a couple of nitpicks inline.

I really appreciate it.
Please see my questions below.

> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_RAW:
> > +		ret = lp8788_get_adc_result(adc, id, val) ? -EIO :
> IIO_VAL_INT;
> > +		break;
> > +	case IIO_CHAN_INFO_SCALE:
> > +		*val = (lp8788_scale[id] / 1000) * 1000;
> > +		*val2 = (lp8788_scale[id] % 1000) * 1000000;
> 
> This looks suspicious. E.g. if the entry in your table has the value
> "1234"
> you'd end up with a scale factor of 1000.234000000. Which looks wrong
> for
> two reasons, given that you return INT_PLUS_MICRO val2 should never
> exceed 6
> decimal digits and secondly val is multiplied by a factor of thousand.
> 
> Can you tell us in what unit the values in lp8788_scale are, that would
> make
> review easier.

The LP8788 has 13 ADC input selection.

ADC selection:
Battery voltage, general ADC1 and so on.

ADC result:
Result = MAX_VALUE * (raw + 0.5) / 4095  except ADC is the charger voltage
If the ADC input is the charger voltage,
Result = MAX_VALUE * (raw + 0.5) / (4095 * 0.48)

The raw value is from the registers.
It has the range between 0 to 4095. (12bits)

MAX_VALUE is constant for each selection.
For the battery voltage, there are three ADC inputs. 5.0/5.5/6.0V
Battery voltage for Max 5.0V = 5.0
Battery voltage for Max 5.5V = 5.5
Battery voltage for Max 6.0V = 6.0
Charger = 6.0
ADC1 = 2.5 

I'm afraid I still misunderstand how IIO ADC works.
Could you me some guide how to setup the scale in the driver?

Thank you.

Best Regards,
Milo
