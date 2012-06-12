Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2FLQHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:07:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59743 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2FLQHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:07:06 -0400
Message-ID: <4FD76927.8040702@wwwdotorg.org>
Date: Tue, 12 Jun 2012 10:07:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/4] i2c: tegra: make sure register writes completes
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com> <1338901800-23968-2-git-send-email-ldewangan@nvidia.com> <20120612075422.GB9230@pengutronix.de> <4FD71709.9040208@nvidia.com>
In-Reply-To: <4FD71709.9040208@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 04:16 AM, Laxman Dewangan wrote:
> On Tuesday 12 June 2012 01:24 PM, Wolfram Sang wrote:
>> * PGP Signed by an unknown key
>>
>> On Tue, Jun 05, 2012 at 06:39:57PM +0530, Laxman Dewangan wrote:
>>> @@ -430,6 +430,13 @@ static irqreturn_t tegra_i2c_isr(int irq, void
>>> *dev_id)
>>>       if (i2c_dev->is_dvc)
>>>           dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
>>>
>>> +    /*
>>> +     * Register write get queued in the PPSB bus and write can
>>> +     * happen later. Read back register to make sure that register
>>> +     * write is completed.
>>> +     */
>>> +    i2c_readl(i2c_dev, I2C_INT_STATUS);
>>
>> Does it make sense to put the read into i2c_writel?
>
> We can not put in i2c_writel() as we also do fifo write using this and
> writing and reading back fifo can drainout the fifo.
> hence putting this here seems more appropriate.

You can put it inside i2c_writel(), but make the read-back conditional
depending on which register was just written. The Tegra SD driver has
similar conditional code in readl/writel to WAR some HW quirks.
