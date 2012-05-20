Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2ETMUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:20:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13190 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2ETMUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:20:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 20 May 2012 05:20:03 -0700
Message-ID: <4FB8E03B.6030404@nvidia.com>
Date: Sun, 20 May 2012 17:44:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <20120519174052.GX4039@opensource.wolfsonmicro.com> <4FB7DEB0.3040001@nvidia.com> <20120519182658.GB4039@opensource.wolfsonmicro.com> <4FB7EE84.7090704@nvidia.com> <20120519205055.GA16590@opensource.wolfsonmicro.com> <4FB80CEE.4050201@nvidia.com> <20120519231347.GD16590@opensource.wolfsonmicro.com> <4FB89E6D.7000206@nvidia.com> <20120520090112.GE16590@opensource.wolfsonmicro.com> <4FB8C9EF.7010400@nvidia.com> <20120520120626.GD20652@opensource.wolfsonmicro.com>
In-Reply-To: <20120520120626.GD20652@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2012 05:36 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sun, May 20, 2012 at 04:09:43PM +0530, Laxman Dewangan wrote:
>> On Sunday 20 May 2012 02:31 PM, Mark Brown wrote:
>>> No.  This is happening because the device tree doesn't have any supplies
>>> mapped for the regulators.  This is nothing at all to do with where the
>>> code looks for the supplies, no matter where it looks there's nothing to
>>> find.
>> No, we should not put the regulator mapping under parent, need to
>> have under "regulator" otherwise we need to fix the issue in dt
>> parsing where first it looks for "regulator" and then parse the rail
>> mapping.
> What is this issue and why should we not fix it?
>

I will go with the way it is done in mc13892 driver and then it is not 
require to change the node layouts for regulator.

>
>
>> I want to have similar fix in my tps65910-regulator.c.
> So why can't you do what mc13892 is doing?
>

Fine, I will post the similar fix in tps65910-regulator to match with 
the mc13892 regulator driver.
I tested this and it worked fine if changes are done in same way.


>> I am sorry that I am not able to explain the issue correctly. I think
>> I will take help from Stephen Warren here to first explain him  and
>> then I will come back for core changes.
> OK, I guess.  I think a key thing here is that these shouldn't be any
> different to any other supply.  Adding something that is specific to
> regulator-regulator supplies doesn't do that so is a clear sign that
> something has been missed.

I tested by moving the regulator supply to top level as you suggested 
and then core driver change does not needed. So I will add this in dt 
documentation for tps65911 and do some more changes in driver to take 
proper pin name.

