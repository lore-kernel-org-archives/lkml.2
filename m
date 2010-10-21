Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0JUQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:16:58 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39609 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758711Ab0JUQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:16:57 -0400
Message-ID: <4CC06760.1080808@metafoo.de>
Date: Thu, 21 Oct 2010 18:16:32 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rklein@nvidia.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        achew@nvidia.com, olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
References: <1287663957-30099-1-git-send-email-lars@metafoo.de> <1287676501-23254-1-git-send-email-lars@metafoo.de> <20101021160008.GD9447@opensource.wolfsonmicro.com>
In-Reply-To: <20101021160008.GD9447@opensource.wolfsonmicro.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:
> 
>> +	irq = gpio_to_irq(pdata->gpio);
>> +	if (irq > 0) {
>> +		ret = request_irq(irq, gpio_charger_irq,
>> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>> +				dev_name(&pdev->dev), charger);
>> +		if (ret)
>> +			dev_warn(&pdev->dev, "Failed to request irq: %d\n", ret);
> 
> It would be good to handle IRQs that can sleep (like those on I2C GPIO
> expanders) here - either always use a threaded IRQ handler (probably
> won't hurt here) or use one if the IRQ can sleep.

I guess the best would be to use `request_any_context_irq`, right?

- Lars
