Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2FNP55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:57:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50167 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2FNP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:57:52 -0400
Message-ID: <4FDA09FC.1010307@wwwdotorg.org>
Date: Thu, 14 Jun 2012 09:57:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V3 1/4] i2c: tegra: make sure register writes completes
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com> <1339582359-7911-2-git-send-email-ldewangan@nvidia.com> <4FD8B7FC.3060708@wwwdotorg.org> <4FD9DAAC.5000709@nvidia.com>
In-Reply-To: <4FD9DAAC.5000709@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 06:35 AM, Laxman Dewangan wrote:
> On Wednesday 13 June 2012 09:25 PM, Stephen Warren wrote:
>> On 06/13/2012 04:12 AM, Laxman Dewangan wrote:
>> @@ -165,6 +165,10 @@ static void i2c_writel(struct tegra_i2c_dev
>> *i2c_dev, u32 val,
>>>       unsigned long reg)
>>>   {
>>>       writel(val, i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
>>> +
>>> +    /* Read back register to make sure that register writes
>>> completed */
>>> +    if (reg != I2C_TX_FIFO)
>>> +        readl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
>> I guess that's fine, but it sure does seem rather heavy-weight. Don't
>> you only need to do the readback if you just wrote to the IRQ status or
>> mask registers, rather than if you wrote to /any/ register other than
>> the FIFO?
> 
> That's what my second patch but based on your earlier review comment, I
> did for every register.

Well, just for the record, in that comment you refer to, I was talking
about the location in the code where the readback should be implemented,
not the set of registers that the readback should happen for. But, it
probably doesn't impact performance. It'd be more self-documenting if
this readback was limited to the specific registers where it was needed
though.
