Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2BIMKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:10:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6270 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2BIMKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:10:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 09 Feb 2012 04:10:42 -0800
Message-ID: <4F33B75F.6050300@nvidia.com>
Date: Thu, 9 Feb 2012 17:39:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] mfd: tps65910: use regmap for device register
 access.
References: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com> <20120208114120.GF3120@opensource.wolfsonmicro.com> <4F32676F.1010305@nvidia.com> <20120208130726.GB5943@opensource.wolfsonmicro.com> <4F3279D6.4000009@nvidia.com> <20120208135816.GE5943@opensource.wolfsonmicro.com> <4F335385.5040400@nvidia.com> <20120209115502.GD3058@opensource.wolfsonmicro.com> <4F33B52A.5020900@nvidia.com> <20120209120312.GE3058@opensource.wolfsonmicro.com>
In-Reply-To: <20120209120312.GE3058@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 February 2012 05:33 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Feb 09, 2012 at 05:29:38PM +0530, Laxman Dewangan wrote:
>
>> I am working on mfd/tps65910.c and function is:
>> static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
>>                                     int bytes, void *src)
>> All your feedback will help me to improve my next two mfd/pmic
>> drivers which I am planning to upstream...
> Yeah, I know that's the i2c_write() function but all the callers I
> noticed were calling it with bytes set to 1.
>
Yes, currently all callers are calling with 1 byte but when we will add 
rtc (which is not there currently), at that time, it may call multibyte 
read/write.
The interface is such that it can support multi-byte transfer. And when 
using for single byte transfer (currently) and if it is cached, 
regmap_raw_write() is creating warnings and that's why I broken transfer 
in multi-transfer in tps65910.c which was not a good idea..


> * Unknown Key
> * 0x6E30FDDD

