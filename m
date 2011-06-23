Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab1FWBOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:14:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54265 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1FWBOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:14:53 -0400
X-AuditID: cbfee61b-b7b2dae000007af9-06-4e02938b2ee3
Date: Thu, 23 Jun 2011 10:14:51 +0900
From: Sangbeom Kim <sbkim73@samsung.com>
Subject: RE: [PATCH 2/3] mfd: Add initial S5M8751 support
In-reply-to: <20110622124820.GD23666@sirena.org.uk>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-id: <016d01cc3142$f3ed4ec0$dbc7ec40$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acww2qxhyxAlED4sTm+rbSDO4648wgAXdYyw
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
 <20110622124820.GD23666@sirena.org.uk>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 09:48 PM +0900, Mark Brown wrote:
> > The WM8994 is a advanced PMIC with AUdio DAC
> > Since it includes regulators, Battery charger, audio dac,
> > it is represented as a multi-function device,
> > though the functionality will be provided by the each driver.
> 
> I think you may have cut'n'pasted bits of this changelog from somewhere
> else without doing all the updates you meant to :)
Sorry, These days I work with 2 board based on S5M8751 & WM8994.
I little confused 8751 with 8994. I will modify it in new patch.

> > +	if (event1 & S5M8751_MASK_PWRKEY1B)
> > +		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY1B);
> > +
> > +	if (event1 & S5M8751_MASK_PWRKEY2B)
> > +		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY2B);
> > +
> > +	if (event1 & S5M8751_MASK_PWRKEY3)
> > +		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY3);
> 
> This looks like the IRQ handler code doesn't need to understand the
> specific events, it can just loop over the registers and fire off
> interrupts based on the bit numbers.
> 
> As I said for the first patch this should all be using genirq.
OK I will modify it.
> 
> > +static irqreturn_t s5m8751_irq(int irq, void *data)
> > +{
> > +	struct s5m8751 *s5m8751 = data;
> > +
> > +	disable_irq_nosync(irq);
> > +	schedule_work(&s5m8751->irq_work);
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> Use a threaded IRQ handler.
OK,
> 
> > +int s5m8751_device_init(struct s5m8751 *s5m8751, int irq,
> > +			struct s5m8751_platform_data *pdata)
> > +{
> > +	int ret = -EINVAL;
> > +	u8 chip_id;
> > +
> > +	if (pdata->init) {
> > +		ret = pdata->init(s5m8751);
> > +		if (ret != 0) {
> > +			dev_err(s5m8751->dev,
> > +			 "Platform init() failed: %d\n", ret);
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	s5m8751_reg_read(s5m8751, S5M8751_CHIP_ID, &chip_id);
> > +	if (!chip_id)
> > +		dev_info(s5m8751->dev, "Found S5M8751 device\n");
> > +	else {
> > +		dev_info(s5m8751->dev, "Didn't Find S5M8751 device\n");
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> 
> I'd really expect the init() callback to run after we've checked that
> we can talk to the device.
OK, I will check it.

Thanks and regards,
SB Kim

