Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2B0GWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:22:13 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44592 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2B0GWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:22:11 -0500
Message-ID: <4F4B2105.4080306@linux.vnet.ibm.com>
Date: Mon, 27 Feb 2012 14:21:57 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
References: <4F3D0F41.1010205@linux.vnet.ibm.com> <1329402561.2293.225.camel@twins> <4F3DEDC3.4010004@linux.vnet.ibm.com> <4F3F025B.5010400@linux.vnet.ibm.com> <1329743311.2293.341.camel@twins> <4F4617AB.2080401@linux.vnet.ibm.com> <4F46F105.2000702@linux.vnet.ibm.com> <4F48E882.6090409@linux.vnet.ibm.com> <20120227041259.GA2331@linux.vnet.ibm.com> <4F4B0F90.6050601@linux.vnet.ibm.com> <20120227051021.GB28139@linux.vnet.ibm.com>
In-Reply-To: <20120227051021.GB28139@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022621-3568-0000-0000-000001462006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 01:10 PM, Srivatsa Vaddagiri wrote:

> * Michael Wang <wangyun@linux.vnet.ibm.com> [2012-02-27 13:07:28]:
> 
>>> Is that benchmark run in root (cpu) cgroup? If so, reweight_entity() should not
>>> kick in at all.
>>
>>
>> That's right, if no children group, 'reweight_entity' won't be called, so I have
>> created a cpuset group under root group named 'rg1', and created a memory group
>> under 'rg1' named 'sub', I attached the current shell to the 'sub' cgroup.
> 
> 'cpu' and 'cpuset' cgroup resource controllers are separate. By above
> steps, you would still be running kern-bench in root cgroup as far as cpu
> cgroup controller is concerned ..


I think I really need some study on cgroup first...I've done some totally useless 
test :( , but still confused that why sys time reduced?

And I got a server with Redhat now, so I will do:

1. cgcreate -g cpu:/subcg1
2. echo $$ > /cgroup/cpu/subcg1/tasks
3. open another shell
4. do 1~3 multi times, plan to get 7 cpu cgroup with 7 shell attached to each one.
5. run kernbench in each shell

Please tell me if I missed some thing :)

Regards,
Michael Wang

> 
> - vatsa


