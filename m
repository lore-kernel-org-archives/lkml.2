Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2JRXjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:39:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38095 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2JRXjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:39:54 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Topic: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Index: Ac2s93gDQSeJyP+TRoq5NeyBztAjJf//0CQA//63kgD//WkZ8A==
Date: Thu, 18 Oct 2012 23:39:39 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641790F2@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F64178FA7@DQHE02.ent.ti.com>
 <507FE604.8070404@metafoo.de> 
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

> > We now have a function in the IIO core which does the sampling +
> > conversion
> > in one step: iio_read_channel_processed. This basically allows you to
> > reduce
> > this function to
> >
> > 	return iio_read_channel_processed(channel, result);
> 
> I was hesitating it before sending this patch. :)
> Currently, LP8788 ADC driver has no iio channel info for PROCESSED.
> Thus, I'll add it in the LP8788 ADC driver first.
> Then I'll send the patch for lp8788-charger again.

I just found you have already handled in case that IIO driver has no IIO_CHAN_INFO_PROCESSED.
(drivers/iio/inkern.c)
So I don't need to worry about the LP8788 ADC driver.
Only the IIO consumer driver(lp8788-charger) needs to be fixed.

Thank you,
Milo
