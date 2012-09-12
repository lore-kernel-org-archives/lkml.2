Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2ILIYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:24:42 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53253 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2ILIYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:24:39 -0400
Message-ID: <505046A5.1050009@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 13:54:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nhorman@tuxdriver.com, David.Laight@aculab.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 2/2] netprio_cgroup: Use memcpy instead of the for-loop
 to copy priomap
References: <20120912060741.11037.37347.stgit@srivatsabhat.in.ibm.com> <20120912060747.11037.42623.stgit@srivatsabhat.in.ibm.com> <20120912.034901.184817520125489015.davem@davemloft.net>
In-Reply-To: <20120912.034901.184817520125489015.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12091208-2000-0000-0000-00000915A36C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 01:19 PM, David Miller wrote:
> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Date: Wed, 12 Sep 2012 11:37:47 +0530
> 
>> +		memcpy(new_priomap->priomap, old_priomap->priomap,
>> +			old_priomap->priomap_len *
>> +					sizeof(old_priomap->priomap[0]));
> 
> This argument indentation is ridiculous.  Try:
> 
> 		memcpy(new_priomap->priomap, old_priomap->priomap,
> 		       old_priomap->priomap_len *
> 		       sizeof(old_priomap->priomap[0]));
> 
> Using TABs exclusively for argumentat indentation is not the goal.
> 
> Rather, lining the arguments up properly so that they sit at the first
> column after the first line's openning parenthesis is what you should
> be trying to achieve.

OK, will fix it, thanks!

> 
> And ignoring whatever stylistic convention we may or may not have, I
> find it impossibly hard to believe that the code quoted above looks
> good even to you.
>

On second thoughts, I think the memcpy in this case will actually be worse
since it will copy the contents in chunks of smaller size than the for-loop.

Or, did you mean to say that this code is plain wrong for some reason?

Regards,
Srivatsa S. Bhat

