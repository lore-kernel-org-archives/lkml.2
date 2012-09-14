Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab2INFRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:17:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50981 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2INFRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:17:05 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: RE: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume functionality
Thread-Topic: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume functionality
Thread-Index: AQHNkZ7iasdC3+d680igP9DfLnFhyJeH4F2AgAFnOcCAAAMVEIAAAcnA
Date: Fri, 14 Sep 2012 05:16:37 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E953D0C@DBDE01.ent.ti.com>
References: <1347532819-505-1-git-send-email-rachna@ti.com>
 <1347532819-505-6-git-send-email-rachna@ti.com>
 <5051D92F.1090309@metafoo.de>
 <4CE347531D4CA947960AF71FF095B9323E953CC3@DBDE01.ent.ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDEFB8F54@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB8F54@BGMAIL02.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:39:20, Venu Byravarasu wrote:
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel- 
> > owner@vger.kernel.org] On Behalf Of Patil, Rachna
> > Sent: Friday, September 14, 2012 10:29 AM
> > To: Lars-Peter Clausen
> > Cc: linux-kernel@vger.kernel.org; linux-input@vger.kernel.org; linux- 
> > iio@vger.kernel.org; Samuel Ortiz; Dmitry Torokhov; Dmitry Torokhov; 
> > Jonathan Cameron
> > Subject: RE: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume 
> > functionality
> > 
> > On Thu, Sep 13, 2012 at 18:31:35, Lars-Peter Clausen wrote:
> > > On 09/13/2012 12:40 PM, Patil, Rachna wrote:
> > > > This patch adds support for suspend/resume of TSC/ADC MFDevice.
> > > >
> > > > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > > > ---
> > > > Changes in v2:
> > > > 	Added this patch newly in this patch series.
> > > >
> > > > Changes in v3:
> > > > 	No changes.
> > > >
> > > >  drivers/iio/adc/ti_adc.c           |   32
> > ++++++++++++++++++++++++++++++++
> > > >  drivers/input/touchscreen/ti_tsc.c |   33
> > +++++++++++++++++++++++++++++++++
> > > >  drivers/mfd/ti_tscadc.c            |   33
> > ++++++++++++++++++++++++++++++++-
> > > >  include/linux/mfd/ti_tscadc.h      |    3 +++
> > > >  4 files changed, 100 insertions(+), 1 deletions(-)
> > > >
> > > > diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c 
> > > > index 56f8af2..69f19f0 100644
> > > > --- a/drivers/iio/adc/ti_adc.c
> > > > +++ b/drivers/iio/adc/ti_adc.c
> > > > @@ -207,6 +207,36 @@ static int __devexit tiadc_remove(struct
> > platform_device *pdev)
> > > >  	return 0;
> > > >  }
> > > >
> > > [...]
> > > >  static struct platform_driver tiadc_driver = {
> > > >  	.driver = {
> > > >  		.name   = "tiadc",
> > > > @@ -214,6 +244,8 @@ static struct platform_driver tiadc_driver = {
> > > >  	},
> > > >  	.probe	= tiadc_probe,
> > > >  	.remove	= __devexit_p(tiadc_remove),
> > > > +	.suspend = adc_suspend,
> > > > +	.resume = adc_resume,
> > > >  };
> > > >
> > >
> > >
> > > Using the suspend/resume callbacks is deprecated, please use
> > dev_pm_ops.
> > > Same comment applies to the other two drivers.
> > 
> > Ok. I will make changes in all the 3 driver to use dev_pm_ops instead 
> > of suspend/resume callbacks.
> 
> Probably you might need to protect suspend/resumes with CONFIG_PM. 

Yes, I will add that as well.

Regards,
Rachna

