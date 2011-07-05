Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1GEDwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 23:52:35 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:35053 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674Ab1GEDwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 23:52:34 -0400
Message-ID: <4E128A7D.9020508@dsn.okisemi.com>
Date: Tue, 05 Jul 2011 12:52:29 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        tglx@linutronix.de
Subject: Re: [PATCH v4] pch_gpio: Support interrupt function
References: <1309486572-2789-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110704163137.GA28042@ponder.secretlab.ca>
In-Reply-To: <20110704163137.GA28042@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

(2011/07/05 1:31), Grant Likely wrote:

>> +#define PCH_IRQ_BASE		23
>
> Yikes!  IRQ ranges should really be dynamically assigned.  Don't hard
> code an irq base.

As we discussed before,
without specifying PCH_IRQ_BASE,
it seemed IRQ number collision issue occurred.
Thus, I added PCH_IRQ_BASE.


>> @@ -202,8 +345,36 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>>   		goto err_gpiochip_add;
>>   	}
>>
>> +	irq_base = irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS, GFP_KERNEL);
>> +	if (irq_base<  0) {
>> +		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
>> +		goto err_irq_alloc_descs;
>> +	}
>> +	chip->irq_base = irq_base;
>
> This looks like it will cause the driver probe to completely fail,
> even if the GPIO portion of the chip was setup correctly.  I would
> think that if GPIO works the driver should at least enable that bit
> even if IRQs are broken.

Do you mean in case of failing irq_alloc_descs,
probe() shouldn't return ERROR but SUCCESS. Right ?

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
