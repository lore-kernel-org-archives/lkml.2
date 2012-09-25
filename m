Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2IYCiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:38:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41336 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2IYCiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:38:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,479,1344182400"; 
   d="scan'208";a="5909675"
Message-ID: <5061196C.8090702@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 10:39:40 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-numa@vger.kernel.org, wency@cn.fujitsu.com,
        mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are onlined.
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com> <1348479536.11847.25.camel@twins> <50602E75.1010304@linux.vnet.ibm.com>
In-Reply-To: <50602E75.1010304@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 10:38:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 10:38:14,
	Serialize complete at 2012/09/25 10:38:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:57 PM, Srivatsa S. Bhat wrote:
> On 09/24/2012 03:08 PM, Peter Zijlstra wrote:
>>> +       hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
>>>          hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
>>>          hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
>>
>> OK, so you really want your notifier to run before cpuset_cpu_active
>> because otherwise you get that crash, yet you fail with the whole order
>> thing.. You should not _ever_ rely on registration order.
>>
>
> IMHO he isn't relying on registration order.. He uses the CPU_PRI_SCHED_ACTIVE
> priority to ensure that the ordering of callbacks is right, isn't it?

Yes, that's right. Thanks. :)

>
> Regards,
> Srivatsa S. Bhat
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

