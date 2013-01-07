Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750835Ab3AGFbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:31:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56859 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AGFbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:31:33 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50EA5D7D.7000703@jp.fujitsu.com>
Date: Mon, 07 Jan 2013 14:30:37 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, akpm@linux-foundation.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 14/14] memory-hotplug: free node_data when a node is
 offlined
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-15-git-send-email-tangchen@cn.fujitsu.com> <50DA7533.6060407@jp.fujitsu.com> <50DC3C26.6060308@cn.fujitsu.com> <50DCE7C0.8070407@jp.fujitsu.com> <50DFD8F4.7040301@cn.fujitsu.com>
In-Reply-To: <50DFD8F4.7040301@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/30 15:02), Wen Congyang wrote:
> At 12/28/2012 08:28 AM, Kamezawa Hiroyuki Wrote:
>> (2012/12/27 21:16), Wen Congyang wrote:
>>> At 12/26/2012 11:55 AM, Kamezawa Hiroyuki Wrote:
>>>> (2012/12/24 21:09), Tang Chen wrote:
>>>>> From: Wen Congyang <wency@cn.fujitsu.com>
>>>>>
>>>>> We call hotadd_new_pgdat() to allocate memory to store node_data. So we
>>>>> should free it when removing a node.
>>>>>
>>>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>>>
>>>> I'm sorry but is it safe to remove pgdat ? All zone cache and zonelists are
>>>> properly cleared/rebuilded in synchronous way ? and No threads are visinting
>>>> zone in vmscan.c ?
>>>
>>> We have rebuilt zonelists when a zone has no memory after offlining some pages.
>>>
>>
>> How do you guarantee that the address of pgdat/zone is not on stack of any kernel
>> threads or other kernel objects without reference counting or other syncing method ?
> 
> No way to guarentee this. But, the kernel should not use the address of pgdat/zone when
> it is offlined.
> 
> Hmm, what about this: reuse the memory when the node is onlined again?
> 

That's the only way which we can go now. Please don't free it.

Thanks,
-Kame


