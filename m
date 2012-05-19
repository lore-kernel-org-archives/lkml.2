Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2ESSZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:25:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6500 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab2ESSY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:24:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 May 2012 11:24:59 -0700
Message-ID: <4FB7E449.1030801@nvidia.com>
Date: Sat, 19 May 2012 23:49:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] regulator: tps65910: set of_node for regulator register
 config
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com> <1337438050-3707-3-git-send-email-ldewangan@nvidia.com> <20120519174829.GZ4039@opensource.wolfsonmicro.com>
In-Reply-To: <20120519174829.GZ4039@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2012 11:18 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sat, May 19, 2012 at 08:04:07PM +0530, Laxman Dewangan wrote:
>
>
>
>> -#ifdef CONFIG_OF
>> -		config.of_node = of_find_node_by_name(tps65910->dev->of_node,
>> +		if (reg_node)
>> +			config.of_node = of_find_node_by_name(reg_node,
>>   							info->name);
>> -#endif
> ...it's changing the value that's being configured.  The changelog
> doesn't explain why this is being done.
>
> Also, why is the ifdef being removed - won't that break the build?
Yaah there is no function for non-dt case and should we add that in of.h?
static inline struct device_node *of_find_node_by_name(struct 
device_node *from,
         const char *name)
{
     return NULL;
}

In this case it will not need to have #ifdef CONFIG_OF in the client code?

