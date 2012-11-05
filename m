Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2KEMCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:02:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5559 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2KEMCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:02:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 05 Nov 2012 03:48:59 -0800
Message-ID: <5097AA42.8090407@nvidia.com>
Date: Mon, 5 Nov 2012 17:30:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: tps80031: add regulator driver for tps80031
References: <1352108658-14289-1-git-send-email-ldewangan@nvidia.com> <1352108658-14289-3-git-send-email-ldewangan@nvidia.com> <20121105104246.GC1385@opensource.wolfsonmicro.com>
In-Reply-To: <20121105104246.GC1385@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for quickest review.

On Monday 05 November 2012 04:12 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Nov 05, 2012 at 03:14:18PM +0530, Laxman Dewangan wrote:
>
>> +	switch (ri->device_flags) {
>> +	case 0:
> Should we be using different versions of the ops depending on the device
> flags rather than having these switches?  It seems like we can't change
> at runtime and it would make the code a lot simpler.

I have single dcdc ops for all DCDC VIO, SMPS1 to 3.
There is different configuration bit for selecting any DCDC to normal, 
extended or offset. As this ops are share, I can not change the callbacks.
However, I rewrite this apis using tables and equation to reduce code size.


> Why the + 1 (and - 1 in the get()).  I'd expect we can just use the
> register value directly as a selector.

The device sets vout = 0 if vsel = 0 and then equation talk about the 
Vmin + vsel * step.
I exported the Vout minimum as Vmin for sel = 0 and hence this is there.

I will export this in true equation in my next patch.

>> +	if (!(ri->config_flags&  VBUS_SW_ONLY)) {
>> +		dev_err(&rdev->dev, "%s() is not supported with flag 0x%08x\n",
>> +			 __func__, ri->config_flags);
>> +		return -EIO;
>> +	}
> Same as the device flags above - we should this be set by changing the
> ops when we register?

Ok, so I will have two ops, hw (empty) and sw(implemented). If sw is 
selected then only sw ops will get initialized and so it will not need 
any checks.

