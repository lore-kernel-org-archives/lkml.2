Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab2B0FHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:07:47 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35407 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2B0FHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:07:40 -0500
Message-ID: <4F4B0F90.6050601@linux.vnet.ibm.com>
Date: Mon, 27 Feb 2012 13:07:28 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
References: <4F308E25.7060101@linux.vnet.ibm.com> <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com> <1329402561.2293.225.camel@twins> <4F3DEDC3.4010004@linux.vnet.ibm.com> <4F3F025B.5010400@linux.vnet.ibm.com> <1329743311.2293.341.camel@twins> <4F4617AB.2080401@linux.vnet.ibm.com> <4F46F105.2000702@linux.vnet.ibm.com> <4F48E882.6090409@linux.vnet.ibm.com> <20120227041259.GA2331@linux.vnet.ibm.com>
In-Reply-To: <20120227041259.GA2331@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022705-8878-0000-0000-000001721605
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 12:12 PM, Srivatsa Vaddagiri wrote:

> * Michael Wang <wangyun@linux.vnet.ibm.com> [2012-02-25 21:56:18]:
> 
>> Hi, Peter
>>
>> I have collected more testing data, here is the test results:
>>
>> Machine:	ThinkPad T420
>> OS:		Ubuntu 11.10
>> Benchmark:	time make -j14 (build kernel)
> 

Hi, Vatsa

Thanks for your reply :)

> Is that benchmark run in root (cpu) cgroup? If so, reweight_entity() should not
> kick in at all.


That's right, if no children group, 'reweight_entity' won't be called, so I have
created a cpuset group under root group named 'rg1', and created a memory group
under 'rg1' named 'sub', I attached the current shell to the 'sub' cgroup.
But I haven't changed any param under the new cgroup, don't know whether that will
cause some trouble or not? I suppose it could using some default value...

> 
> static void update_cfs_shares(struct cfs_rq *cfs_rq)
> {
> 
>         ..
> 
>         if (!se || throttled_hierarchy(cfs_rq))
>                 return;
> 
>         ..
> 
> 	reweight_entity();
> }
> 
> If you want to stress reweight_entity() create several (cpu) cgroups
> and launch workload like kernbench in each of them ..


Thanks for your suggestion, now I see that only using 1 children group is really
not enough, I think I should try another round of test with kernbench, and also
I was suggested to use oprofile to trace the 'reweight_entity', wish I can get
some real proof from them. 

Regards,
Michael Wang 

> 
> - vatsa


