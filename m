Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2ILGGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:06:18 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38510 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2ILGGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:06:16 -0400
Message-ID: <50502624.8040409@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 11:35:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Laight <David.Laight@aculab.com>
CC: davem@davemloft.net, nhorman@tuxdriver.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] netprio_cgroup: Optimize the priomap copy loop slightly
References: <20120911112231.13852.61794.stgit@srivatsabhat.in.ibm.com> <20120911112237.13852.1095.stgit@srivatsabhat.in.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B6FE9@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6FE9@saturn3.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091206-0260-0000-0000-000001D5E8C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 05:12 PM, David Laight wrote:
>> -	for (i = 0;
>> -	     old_priomap && (i < old_priomap->priomap_len);
>> -	     i++)
>> -		new_priomap->priomap[i] = old_priomap->priomap[i];
>> +	if (old_priomap) {
>> +		old_len = old_priomap->priomap_len;
>> +
>> +		for (i = 0; i < old_len; i++)
>> +			new_priomap->priomap[i] = old_priomap->priomap[i];
>> +	}
> 
> Or:
> 	memcpy(new_priomap->priomap, old_priomap->priomap,
> 		old_priomap->priomap_len * sizeof old_priomap->priomap[0]);
> 

Ah, indeed that would be better. I'll send out an updated version of the
patches. Thanks!

Regards,
Srivatsa S. Bhat

