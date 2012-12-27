Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2L0DKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 22:10:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:18341 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab2L0DKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 22:10:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,360,1355068800"; 
   d="scan'208";a="6482683"
Message-ID: <50DBBBEF.70701@cn.fujitsu.com>
Date: Thu, 27 Dec 2012 11:09:35 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: akpm@linux-foundation.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 04/14] memory-hotplug: remove /sys/firmware/memmap/X
 sysfs
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-5-git-send-email-tangchen@cn.fujitsu.com> <50DA6F5A.2070601@jp.fujitsu.com>
In-Reply-To: <50DA6F5A.2070601@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/27 11:10:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/27 11:10:18,
	Serialize complete at 2012/12/27 11:10:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 11:30 AM, Kamezawa Hiroyuki wrote:
>> @@ -41,6 +42,7 @@ struct firmware_map_entry {
>>    	const char		*type;	/* type of the memory range */
>>    	struct list_head	list;	/* entry for the linked list */
>>    	struct kobject		kobj;   /* kobject for each entry */
>> +	unsigned int		bootmem:1; /* allocated from bootmem */
>>    };
> 
> Can't we detect from which the object is allocated from, slab or bootmem ?
> 
> Hm, for example,
> 
>      PageReserved(virt_to_page(address_of_obj)) ?
>      PageSlab(virt_to_page(address_of_obj)) ?
> 

Hi Kamezawa-san,

I think we can detect it without a new member. I think bootmem:1 member
is just for convenience. I think I can remove it. :)

Thanks. :)
