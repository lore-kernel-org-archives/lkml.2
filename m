Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2HPAml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:42:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53358 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2HPAmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:42:39 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>
CC: "jic23@kernel.org" <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: RE: [PATCH v2] iio: adc: add new lp8788 adc driver
Thread-Topic: [PATCH v2] iio: adc: add new lp8788 adc driver
Thread-Index: Ac12xqP+Bc5s8uCiQs6e2HGT/GnXAgDuTq8AAC6oSXA=
Date: Thu, 16 Aug 2012 00:42:26 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEFD05@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EEF1F7@DQHE02.ent.ti.com>
 <502B62AC.2030801@metafoo.de>
In-Reply-To: <502B62AC.2030801@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_RAW:
> > +		*val = result;
> > +		return IIO_VAL_INT;
> > +	case IIO_CHAN_INFO_SCALE:
> > +		*val = adc_const[id] * ((result * 1000 + 500) / 1000);
> 
> This looks wrong. The IIO_CHAN_INFO_SCALE attribute is the factor by
> which
> IIO_CHAN_INFO_RAW needs to be multiplied to get the value in the proper
> unit,
> which is specified in the IIO ABI spec. E.g. milli volts for voltages.
> 
> What you return here seems to be the IIO_CHAN_INFO_PROCESSED attribute.
> Which
> basically is raw * scale.

Thanks a lot for your review.

Any way to get the result with offset value in the iio-consumer side?
What I need is as below.

  result = raw * scale + offset

At this moment, there are two apis() for reading the iio channel
- iio_read_channel_raw() and iio_read_channel_scale().

Does it sound good if I add iio_read_channel_offset() consumer api
using IIO_CHAN_INFO_OFFSET?

Best Regards,
Milo

