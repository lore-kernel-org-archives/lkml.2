Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2IZKJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:09:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33787 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2IZKJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:09:19 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: RE: [PATCH v4 5/5] MFD: ti_tscadc: add suspend/resume functionality
Thread-Topic: [PATCH v4 5/5] MFD: ti_tscadc: add suspend/resume functionality
Thread-Index: AQHNm6lzpqtiuVnbHEGO6q7HwPN1EJeb0DaAgACUJzA=
Date: Wed, 26 Sep 2012 10:09:03 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E95738D@DBDE01.ent.ti.com>
References: <1348636814-14129-1-git-send-email-rachna@ti.com>
 <1348636814-14129-6-git-send-email-rachna@ti.com> <5062A373.4000707@ti.com>
In-Reply-To: <5062A373.4000707@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: ER4n UCX4 V30N WVCN YJaV aoQ4 bKgk cKGU eKX4 gCXs jf0j
 j68p l0gu mHro n62d
 tHwd;7;ZABtAGkAdAByAHkALgB0AG8AcgBvAGsAaABvAHYAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAdABvAHIAQABtAGEAaQBsAC4AcgB1ADsAagBpAGMAMgAzAEAAYwBhAG0ALgBhAGMALgB1AGsAOwBsAGkAbgB1AHgALQBpAGkAbwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AaQBuAHAAdQB0AEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcwBhAG0AZQBvAEAAbABpAG4AdQB4AC4AaQBuAHQAZQBsAC4AYwBvAG0A;Sosha1_v1;7;{2823F7A9-20FA-4B99-BAA6-01CC4B0C2B67};cgBhAGMAaABuAGEAQAB0AGkALgBjAG8AbQA=;Wed,
 26 Sep 2012 10:08:53
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYANAAgADUALwA1AF0AIABNAEYARAA6ACAAdABpAF8AdABzAGMAYQBkAGMAOgAgAGEAZABkACAAcwB1AHMAcABlAG4AZAAvAHIAZQBzAHUAbQBlACAAZgB1AG4AYwB0AGkAbwBuAGEAbABpAHQAeQA=
x-cr-puzzleid: {2823F7A9-20FA-4B99-BAA6-01CC4B0C2B67}
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

On Wed, Sep 26, 2012 at 12:10:51, Datta, Shubhrajyoti wrote:
> On Wednesday 26 September 2012 10:50 AM, Patil, Rachna wrote:
> > This patch adds support for suspend/resume of
> > TSC/ADC MFDevice.
> this should be merged with the patch adding support else
> we may end up in a case where patch a does the runtime calls
> and the call back  handlers added later.

I am adding both the runtime calls and the handlers in this patch.
I think maintaining this as a separate patch in better in terms
of readability as well.

Regards,
Rachna

> >
> > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > ---
> > Changes in v2:
> > 	Added this patch newly in this patch series.
> >
> > Changes in v3:
> > 	No changes.
> >
> > Changes in v4:
> > 	Replaced suspend/resume callbacks with dev_pm_ops.
> >
> >  drivers/iio/adc/ti_am335x_adc.c           |   42 +++++++++++++++++++++++++++++
> >  drivers/input/touchscreen/ti_am335x_tsc.c |   42 +++++++++++++++++++++++++++++
> >  drivers/mfd/ti_am335x_tscadc.c            |   41 +++++++++++++++++++++++++++-
> >  include/linux/mfd/ti_am335x_tscadc.h      |    3 ++
> >  4 files changed, 127 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> > index 9e1b3ac..b16f944 100644
> > --- a/drivers/iio/adc/ti_am335x_adc.c
> > +++ b/drivers/iio/adc/ti_am335x_adc.c
> > @@ -200,10 +200,52 @@ static int __devexit tiadc_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM
> > +static int tiadc_suspend(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> > +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> > +	struct ti_tscadc_dev *tscadc_dev = dev->platform_data;
> > +	unsigned int idle;
> > +
> > +	if (!device_may_wakeup(tscadc_dev->dev)) {
> > +		idle = adc_readl(adc_dev, REG_CTRL);
> > +		idle &= ~(CNTRLREG_TSCSSENB);
> > +		adc_writel(adc_dev, REG_CTRL, (idle |
> > +				CNTRLREG_POWERDOWN));
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int tiadc_resume(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> > +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> > +	unsigned int restore;
> > +
> > +	/* Make sure ADC is powered up */
> > +	restore = adc_readl(adc_dev, REG_CTRL);
> > +	restore &= ~(CNTRLREG_POWERDOWN);
> > +	adc_writel(adc_dev, REG_CTRL, restore);
> > +
> > +	adc_step_config(adc_dev);
> > +	return 0;
> > +}
> > +
> > +static const struct dev_pm_ops tiadc_pm_ops = {
> > +	.suspend = tiadc_suspend,
> > +	.resume = tiadc_resume,
> > +};
> > +#define TIADC_PM_OPS (&tiadc_pm_ops)
> > +#else
> > +#define TIADC_PM_OPS NULL
> > +#endif
> > +
> >  static struct platform_driver tiadc_driver = {
> >  	.driver = {
> >  		.name   = "tiadc",
> >  		.owner = THIS_MODULE,
> > +		.pm	= TIADC_PM_OPS,
> >  	},
> >  	.probe	= tiadc_probe,
> >  	.remove	= __devexit_p(tiadc_remove),
> > diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> > index 2d9dec1..b17dbe4 100644
> > --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> > +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> > @@ -338,12 +338,54 @@ static int __devexit tscadc_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM
> > +static int titsc_suspend(struct device *dev)
> > +{
> > +	struct ti_tscadc_dev *tscadc_dev = dev->platform_data;
> > +	struct tscadc *ts_dev = tscadc_dev->tsc;
> > +	unsigned int idle;
> > +
> > +	if (device_may_wakeup(tscadc_dev->dev)) {
> > +		idle = tscadc_readl(ts_dev, REG_IRQENABLE);
> > +		tscadc_writel(ts_dev, REG_IRQENABLE,
> > +				(idle | IRQENB_HW_PEN));
> > +		tscadc_writel(ts_dev, REG_IRQWAKEUP, IRQWKUP_ENB);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int titsc_resume(struct device *dev)
> > +{
> > +	struct ti_tscadc_dev *tscadc_dev = dev->platform_data;
> > +	struct tscadc *ts_dev = tscadc_dev->tsc;
> > +
> > +	if (device_may_wakeup(tscadc_dev->dev)) {
> > +		tscadc_writel(ts_dev, REG_IRQWAKEUP,
> > +				0x00);
> > +		tscadc_writel(ts_dev, REG_IRQCLR, IRQENB_HW_PEN);
> > +	}
> > +	tscadc_step_config(ts_dev);
> > +	tscadc_writel(ts_dev, REG_FIFO0THR,
> > +			ts_dev->steps_to_configure);
> > +	return 0;
> > +}
> > +
> > +static const struct dev_pm_ops titsc_pm_ops = {
> > +	.suspend = titsc_suspend,
> > +	.resume  = titsc_resume,
> > +};
> > +#define TITSC_PM_OPS (&titsc_pm_ops)
> > +#else
> > +#define TITSC_PM_OPS NULL
> > +#endif
> > +
> >  static struct platform_driver ti_tsc_driver = {
> >  	.probe	= tscadc_probe,
> >  	.remove	= __devexit_p(tscadc_remove),
> >  	.driver	= {
> >  		.name   = "tsc",
> >  		.owner	= THIS_MODULE,
> > +		.pm	= TITSC_PM_OPS,
> >  	},
> >  };
> >  module_platform_driver(ti_tsc_driver);
> > diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> > index 45d66e5..7e949e8 100644
> > --- a/drivers/mfd/ti_am335x_tscadc.c
> > +++ b/drivers/mfd/ti_am335x_tscadc.c
> > @@ -170,6 +170,7 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
> >  	if (err < 0)
> >  		goto err_disable_clk;
> >  
> > +	device_init_wakeup(&pdev->dev, true);
> >  	platform_set_drvdata(pdev, tscadc);
> >  	return 0;
> >  
> > @@ -203,14 +204,52 @@ static int __devexit ti_tscadc_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM
> > +static int tscadc_suspend(struct device *dev)
> > +{
> > +	struct ti_tscadc_dev	*tscadc_dev = dev_get_drvdata(dev);
> > +
> > +	tscadc_writel(tscadc_dev, REG_SE, 0x00);
> > +	pm_runtime_put_sync(dev);
> > +	return 0;
> > +}
> > +
> > +static int tscadc_resume(struct device *dev)
> > +{
> > +	struct ti_tscadc_dev	*tscadc_dev = dev_get_drvdata(dev);
> > +	unsigned int restore, ctrl;
> > +
> > +	pm_runtime_get_sync(dev);
> > +
> > +	/* context restore */
> > +	ctrl = CNTRLREG_STEPCONFIGWRT | CNTRLREG_TSCENB |
> > +			CNTRLREG_STEPID | CNTRLREG_4WIRE;
> > +	tscadc_writel(tscadc_dev, REG_CTRL, ctrl);
> > +	tscadc_idle_config(tscadc_dev);
> > +	tscadc_writel(tscadc_dev, REG_SE, STPENB_STEPENB);
> > +	restore = tscadc_readl(tscadc_dev, REG_CTRL);
> > +	tscadc_writel(tscadc_dev, REG_CTRL,
> > +			(restore | CNTRLREG_TSCSSENB));
> > +	return 0;
> > +}
> > +
> > +static const struct dev_pm_ops tscadc_pm_ops = {
> > +	.suspend = tscadc_suspend,
> > +	.resume = tscadc_resume,
> > +};
> > +#define TSCADC_PM_OPS (&tscadc_pm_ops)
> > +#else
> > +#define TSCADC_PM_OPS NULL
> > +#endif
> > +
> >  static struct platform_driver ti_tscadc_driver = {
> >  	.driver = {
> >  		.name   = "ti_tscadc",
> >  		.owner	= THIS_MODULE,
> > +		.pm	= TSCADC_PM_OPS,
> >  	},
> >  	.probe	= ti_tscadc_probe,
> >  	.remove	= __devexit_p(ti_tscadc_remove),
> > -
> >  };
> >  
> >  module_platform_driver(ti_tscadc_driver);
> > diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> > index bd9fe1d..c7facdc 100644
> > --- a/include/linux/mfd/ti_am335x_tscadc.h
> > +++ b/include/linux/mfd/ti_am335x_tscadc.h
> > @@ -40,6 +40,9 @@
> >  #define REG_FIFO1		0x200
> >  
> >  /*	Register Bitfields	*/
> > +/* IRQ wakeup enable */
> > +#define IRQWKUP_ENB		BIT(0)
> > +
> >  /* Step Enable */
> >  #define STEPENB_MASK		(0x1FFFF << 0)
> >  #define STEPENB(val)		((val) << 0)
> 
> 

