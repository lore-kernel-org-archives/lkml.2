Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2FNMpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:45:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6790 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2FNMpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:45:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Jun 2012 05:44:59 -0700
Message-ID: <4FD9DAAC.5000709@nvidia.com>
Date: Thu, 14 Jun 2012 18:05:56 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V3 1/4] i2c: tegra: make sure register writes completes
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com> <1339582359-7911-2-git-send-email-ldewangan@nvidia.com> <4FD8B7FC.3060708@wwwdotorg.org>
In-Reply-To: <4FD8B7FC.3060708@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2012 09:25 PM, Stephen Warren wrote:
> On 06/13/2012 04:12 AM, Laxman Dewangan wrote:
> @@ -165,6 +165,10 @@ static void i2c_writel(struct tegra_i2c_dev 
> *i2c_dev, u32 val,
>>   	unsigned long reg)
>>   {
>>   	writel(val, i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
>> +
>> +	/* Read back register to make sure that register writes completed */
>> +	if (reg != I2C_TX_FIFO)
>> +		readl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
> I guess that's fine, but it sure does seem rather heavy-weight. Don't
> you only need to do the readback if you just wrote to the IRQ status or
> mask registers, rather than if you wrote to /any/ register other than
> the FIFO?

That's what my second patch but based on your earlier review comment, I 
did for every register.

I think it will not matter much as we dont write all register with every 
transaction, only during initialization.
Then for each transfer we write manly on Tx fifo and interrupt 
mask/status register and hence not too much overweight.

