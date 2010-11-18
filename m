Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0KRTUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:20:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31252 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0KRTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:20:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6171"; a="63241767"
Date: Thu, 18 Nov 2010 11:20:28 -0800 (PST)
From: Gregory Bean <gbean@codeaurora.org>
X-X-Sender: gbean@gbean-linux.qualcomm.com
To: Pavan Kondeti <pkondeti@codeaurora.org>
cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] msm: gpio: Add irq support to v2 gpiolib.
In-Reply-To: <20101118111527.GD11700@codeaurora.org>
Message-ID: <alpine.DEB.2.00.1011181115220.9788@gbean-linux.qualcomm.com>
References: <1289943516-11367-1-git-send-email-gbean@codeaurora.org> <1289943516-11367-2-git-send-email-gbean@codeaurora.org> <20101118111527.GD11700@codeaurora.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	spin_lock_irqsave(&tlmm_lock, irq_flags);
>> +	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
>> +		if (!test_bit(i, msm_gpio.wake_irqs))
>> +			writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(i));
>> +	}
> If none of the enabled irqs is configured as a wakeup source, should not we
> disable the summary IRQ?

I do not believe there is a need.  If no irqs are wakeup sources, then
the summary irq is also not a wakeup source, see msm_gpio_irq_set_wake().
And if the GIC will mask the TLMM block appropriately during system PM
without further bit-twiddling from me, why complicate my PM hooks further?

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
