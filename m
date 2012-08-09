Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2HIIdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:33:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52669 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab2HIIdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:33:49 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: RE: [PATCH 1/6] mfd: add lp8788 mfd driver
Thread-Topic: [PATCH 1/6] mfd: add lp8788 mfd driver
Thread-Index: Ac1k8i6xsVnWXGXAR2GxE5eW2yYAsf//fuIA/91SY+A=
Date: Thu, 9 Aug 2012 08:32:59 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEBC6E@DBDE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FD79B@DQHE02.ent.ti.com>
 <20120718145032.GB4495@opensource.wolfsonmicro.com>
In-Reply-To: <20120718145032.GB4495@opensource.wolfsonmicro.com>
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

> > +static irqreturn_t lp8788_irq_handler(int irq, void *ptr)
> > +{
> > +	struct lp8788_irq_data *irqd = ptr;
> > +	unsigned long delay = msecs_to_jiffies(DEBOUNCE_MSEC);
> > +
> > +	queue_delayed_work(irqd->thread, &irqd->work, delay);
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> Why a delayed work?  That's *very* unusual.
> 
> > +	if (!lp->pdata) {
> > +		dev_warn(lp->dev, "no platform data for irq\n");
> > +		goto no_err;
> > +	}
> 
> Given that you're using irq domains why does the device need platform
> data?
> 
> > +	if (irq_base) {
> > +		irq_base = irq_alloc_descs(irq_base, 0, LP8788_INT_MAX, 0);
> > +		if (irq_base < 0) {
> > +			dev_warn(lp->dev, "no allocated irq: %d\n", irq_base);
> > +			goto no_err;
> > +		}
> > +	}
> 
> This shouldn't be needed with irq domains.

In patch v2, generic irq chip is used for interrupt handling.
At this moment, no need to support irq domain with lp8788 driver.
Title: [PATCH v2 1/3] mfd: add lp8788 mfd driver

> > +EXPORT_SYMBOL(lp8788_read_byte);
> 
> You're reexporting regmap functionality with looser licensing
> requirements...
> 

All EXPORT_SYMBOLs were replaced with *_GPL() in the same patch v2.
 
> > +unsigned int lp8788_get_adc(struct lp8788 *lp, enum lp8788_adc_id id,
> > +			enum lp8788_adc_resolution res)
> 
> For new drivers the ADC should probably be integrated into IIO.

New iio driver patch was submitted.
Title : [PATCH 2/3] iio: adc: add new lp8788 adc driver

Thanks a lot for your detailed review.

Best Regards,
Milo



