Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2L3Fzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:55:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65435 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2L3Fzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:55:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,379,1355068800"; 
   d="scan'208";a="6500622"
Message-ID: <50DFD8F4.7040301@cn.fujitsu.com>
Date: Sun, 30 Dec 2012 14:02:28 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-15-git-send-email-tangchen@cn.fujitsu.com> <50DA7533.6060407@jp.fujitsu.com> <50DC3C26.6060308@cn.fujitsu.com> <50DCE7C0.8070407@jp.fujitsu.com>
In-Reply-To: <50DCE7C0.8070407@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/30 13:55:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/30 13:55:21,
	Serialize complete at 2012/12/30 13:55:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 12/28/2012 08:28 AM, Kamezawa Hiroyuki Wrote:
> (2012/12/27 21:16), Wen Congyang wrote:
>> At 12/26/2012 11:55 AM, Kamezawa Hiroyuki Wrote:
>>> (2012/12/24 21:09), Tang Chen wrote:
>>>> From: Wen Congyang <wency@cn.fujitsu.com>
>>>>
>>>> We call hotadd_new_pgdat() to allocate memory to store node_data. So we
>>>> should free it when removing a node.
>>>>
>>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>>
>>> I'm sorry but is it safe to remove pgdat ? All zone cache and zonelists are
>>> properly cleared/rebuilded in synchronous way ? and No threads are visinting
>>> zone in vmscan.c ?
>>
>> We have rebuilt zonelists when a zone has no memory after offlining some pages.
>>
> 
> How do you guarantee that the address of pgdat/zone is not on stack of any kernel
> threads or other kernel objects without reference counting or other syncing method ?

No way to guarentee this. But, the kernel should not use the address of pgdat/zone when
it is offlined.

Hmm, what about this: reuse the memory when the node is onlined again?

Thanks
Wen Congyang

> 
> 
> Thanks,
> -Kame
> 
> 
> 

