Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2IRBcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:32:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27328 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab2IRBcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:32:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,440,1344182400"; 
   d="scan'208";a="5860762"
Message-ID: <5057D079.6020709@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 09:38:01 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, len.brown@intel.com,
        pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        rusty@rustcorp.com.au, bhelgaas@google.com,
        David Rientjes <rientjes@google.c>
Subject: Re: [PATCH 2/2] numa: don't check if node is NUMA_NO_NODE
References: <504457C8.10209@cn.fujitsu.com>	<5044665C.5020909@cn.fujitsu.com> <20120904161102.143ceb6d.akpm@linux-foundation.org>
In-Reply-To: <20120904161102.143ceb6d.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 09:32:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 09:32:45,
	Serialize complete at 2012/09/18 09:32:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/05/2012 07:11 AM, Andrew Morton Wrote:
> On Mon, 03 Sep 2012 16:12:12 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> If we don't debug per_cpu maps, the cpu's node is stored in per_cpu variable
>> numa_node. If node is NUMA_NO_NODE, it means the caller want to clear the
>> cpu's node. So we should also call set_cpu_numa_node() in this case.
> 
> The changelog is missing important information.
> 
> What is the runtime effect of the patch?  In other words, please fully
> describe the runtime effects of the bug which the patch fixed.
> 
> Please always provide this information.  It will help others decide
> which kernel version(s) should be patched, and will help the
> maintainers of other kernel trees (especially vendor trees) to work out
> whether they should backport the fix into their kernels.

Sorry for later reply. I found this bug when I try to fix a bug by patch 1/2
(The bug is descriptioned in patch 1/2).

Thanks
Wen Congyang

> 
>> --- a/arch/x86/mm/numa.c
>> +++ b/arch/x86/mm/numa.c
>> @@ -97,8 +97,7 @@ void __cpuinit numa_set_node(int cpu, int node)
>>  #endif
>>  	per_cpu(x86_cpu_to_node_map, cpu) = node;
>>  
>> -	if (node != NUMA_NO_NODE)
>> -		set_cpu_numa_node(cpu, node);
>> +	set_cpu_numa_node(cpu, node);
>>  }
>>  
>>  void __cpuinit numa_clear_node(int cpu)
> 
> 

