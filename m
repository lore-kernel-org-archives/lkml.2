Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954Ab2ILR6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:58:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60958 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2ILR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:58:49 -0400
Date: Wed, 12 Sep 2012 13:58:44 -0400 (EDT)
Message-Id: <20120912.135844.2128028507911988895.davem@davemloft.net>
To: srivatsa.bhat@linux.vnet.ibm.com
Cc: nhorman@tuxdriver.com, David.Laight@aculab.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 2/2] netprio_cgroup: Use memcpy instead of the
 for-loop to copy priomap
From: David Miller <davem@davemloft.net>
In-Reply-To: <505046A5.1050009@linux.vnet.ibm.com>
References: <20120912060747.11037.42623.stgit@srivatsabhat.in.ibm.com>
	<20120912.034901.184817520125489015.davem@davemloft.net>
	<505046A5.1050009@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 13:54:05 +0530

> On 09/12/2012 01:19 PM, David Miller wrote:
>> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>> Date: Wed, 12 Sep 2012 11:37:47 +0530
>> 
>>> +		memcpy(new_priomap->priomap, old_priomap->priomap,
>>> +			old_priomap->priomap_len *
>>> +					sizeof(old_priomap->priomap[0]));
>> 
>> This argument indentation is ridiculous.  Try:
>> 
>> 		memcpy(new_priomap->priomap, old_priomap->priomap,
>> 		       old_priomap->priomap_len *
>> 		       sizeof(old_priomap->priomap[0]));
>> 
>> Using TABs exclusively for argumentat indentation is not the goal.
>> 
>> Rather, lining the arguments up properly so that they sit at the first
>> column after the first line's openning parenthesis is what you should
>> be trying to achieve.
> 
> OK, will fix it, thanks!
> 
>> 
>> And ignoring whatever stylistic convention we may or may not have, I
>> find it impossibly hard to believe that the code quoted above looks
>> good even to you.
>>
> 
> On second thoughts, I think the memcpy in this case will actually be worse
> since it will copy the contents in chunks of smaller size than the for-loop.

I meant just coding style wise, not semantically.
