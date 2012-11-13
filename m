Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2KMRvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:51:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4414 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KMRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:51:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 09:51:15 -0800
Message-ID: <50A287F2.4070008@nvidia.com>
Date: Tue, 13 Nov 2012 23:18:34 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com> <1352646721-8350-2-git-send-email-ldewangan@nvidia.com> <20121113074623.GL18224@opensource.wolfsonmicro.com>
In-Reply-To: <20121113074623.GL18224@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 01:16 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sun, Nov 11, 2012 at 08:42:00PM +0530, Laxman Dewangan wrote:
>
>> +#define TPS80031_RGEMAP_IRQ(_reg, _mask)			\
> Why RGEMAP_IRQ?

I think not require. I will remove it.

>> +static struct regmap_irq_chip tps80031_irq_chip = {
>> +	.name = "tps80031",
>> +	.irqs = tps80031_main_irqs,
>> +	.num_irqs = ARRAY_SIZE(tps80031_main_irqs),
>> +	.num_regs = 3,
>> +	.status_base = TPS80031_INT_STS_A,
>> +	.mask_base = TPS80031_INT_MSK_LINE_A,
>> +	.wake_base = 1,
> I'm not sure your wake_base setting is sane here - this is expected to
> be a register.  If it is a register why is it not a #define?

There is no wake register. Here I kept for the incerease the wake conut 
so that irq_set_irq_wake() can be called.

I think it is also not correct after change
regmap: irq: initialize all irqs to wake disabled

I need to set the irq_wake(0 without the register.


>> +static int __devinit tps80031_irq_init(struct tps80031 *tps80031, int irq,
>> +				int irq_base)
>> +{
>> +	struct device *dev = tps80031->dev;
>> +	int i, ret;
>> +
>> +	for (i = 0; i<  3; i++)
>> +		tps80031_write(dev, SLAVE_ID2,
>> +				TPS80031_INT_MSK_STS_A + i, 0x00);
> regmap ought to be masking everything for you on init.

There is 2 sets of registers which need to be configure, MASK and LINE 
enable.

regmap take care of mask only.
> * Unknown Key
> * 0x7EA229BD

