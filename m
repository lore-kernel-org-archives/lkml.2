Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126Ab0GTJyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:54:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24322 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100Ab0GTJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:54:06 -0400
Date: Tue, 20 Jul 2010 18:54:04 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 2/3] mfd: MAX8998: Add interrupts support
In-reply-to: <20100720085554.GH10222@rakim.wolfsonmicro.main>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@slimlogic.co.uk,
        akpm@linux-foundation.org, a.zummo@towertech.it, gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Message-id: <4C45723C.1000009@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
 <1279609058-32319-2-git-send-email-jy0922.shim@samsung.com>
 <20100720085554.GH10222@rakim.wolfsonmicro.main>
X-OriginalArrivalTime: 20 Jul 2010 09:54:04.0912 (UTC)
 FILETIME=[7D11EF00:01CB27F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/2010 5:55 PM, Mark Brown wrote:
> On Tue, Jul 20, 2010 at 03:57:37PM +0900, Joonyoung Shim wrote:
>> Use genirq and provide seperated file for interrupts support.
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> ...
> 
>> +
>> +	for (i = 0; i < ARRAY_SIZE(max8998->irq_masks_cur); i++) {
>> +		/*
>> +		 * If there's been a change in the mask write it back
>> +		 * to the hardware.
>> +		 */
>> +		if (max8998->irq_masks_cur[i] != max8998->irq_masks_cache[i]) {
>> +			max8998->irq_masks_cache[i] = max8998->irq_masks_cur[i];
>> +			max8998_write_reg(max8998->i2c, MAX8998_REG_IRQM1 + i,
>> +					max8998->irq_masks_cur[i]);
>> +		}
> 
> This code all looks oddly familiar :)

Yes, i didn't have any needs to use other way.

> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
