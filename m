Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2INFJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:09:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1282 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2INFJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:09:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Sep 2012 22:01:26 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Patil, Rachna" <rachna@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Date: Fri, 14 Sep 2012 10:39:20 +0530
Subject: RE: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume functionality
Thread-Topic: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume functionality
Thread-Index: AQHNkZ7iasdC3+d680igP9DfLnFhyJeH4F2AgAFnOcCAAAMVEA==
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDEFB8F54@BGMAIL02.nvidia.com>
References: <1347532819-505-1-git-send-email-rachna@ti.com>
 <1347532819-505-6-git-send-email-rachna@ti.com>
 <5051D92F.1090309@metafoo.de>
 <4CE347531D4CA947960AF71FF095B9323E953CC3@DBDE01.ent.ti.com>
In-Reply-To: <4CE347531D4CA947960AF71FF095B9323E953CC3@DBDE01.ent.ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Patil, Rachna
> Sent: Friday, September 14, 2012 10:29 AM
> To: Lars-Peter Clausen
> Cc: linux-kernel@vger.kernel.org; linux-input@vger.kernel.org; linux-
> iio@vger.kernel.org; Samuel Ortiz; Dmitry Torokhov; Dmitry Torokhov;
> Jonathan Cameron
> Subject: RE: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume
> functionality
> 
> On Thu, Sep 13, 2012 at 18:31:35, Lars-Peter Clausen wrote:
> > On 09/13/2012 12:40 PM, Patil, Rachna wrote:
> > > This patch adds support for suspend/resume of TSC/ADC MFDevice.
> > >
> > > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > > ---
> > > Changes in v2:
> > > 	Added this patch newly in this patch series.
> > >
> > > Changes in v3:
> > > 	No changes.
> > >
> > >  drivers/iio/adc/ti_adc.c           |   32
> ++++++++++++++++++++++++++++++++
> > >  drivers/input/touchscreen/ti_tsc.c |   33
> +++++++++++++++++++++++++++++++++
> > >  drivers/mfd/ti_tscadc.c            |   33
> ++++++++++++++++++++++++++++++++-
> > >  include/linux/mfd/ti_tscadc.h      |    3 +++
> > >  4 files changed, 100 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c index
> > > 56f8af2..69f19f0 100644
> > > --- a/drivers/iio/adc/ti_adc.c
> > > +++ b/drivers/iio/adc/ti_adc.c
> > > @@ -207,6 +207,36 @@ static int __devexit tiadc_remove(struct
> platform_device *pdev)
> > >  	return 0;
> > >  }
> > >
> > [...]
> > >  static struct platform_driver tiadc_driver = {
> > >  	.driver = {
> > >  		.name   = "tiadc",
> > > @@ -214,6 +244,8 @@ static struct platform_driver tiadc_driver = {
> > >  	},
> > >  	.probe	= tiadc_probe,
> > >  	.remove	= __devexit_p(tiadc_remove),
> > > +	.suspend = adc_suspend,
> > > +	.resume = adc_resume,
> > >  };
> > >
> >
> >
> > Using the suspend/resume callbacks is deprecated, please use
> dev_pm_ops.
> > Same comment applies to the other two drivers.
> 
> Ok. I will make changes in all the 3 driver to use dev_pm_ops instead of
> suspend/resume callbacks.

Probably you might need to protect suspend/resumes with CONFIG_PM. 

> 
> Regards,
> Rachna
> 
> >
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
