Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2L0DL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 22:11:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42562 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab2L0DLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 22:11:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,360,1355068800"; 
   d="scan'208";a="6482701"
Message-ID: <50DBBC40.6040700@cn.fujitsu.com>
Date: Thu, 27 Dec 2012 11:10:56 +0800
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
Subject: Re: [PATCH v5 02/14] memory-hotplug: check whether all memory blocks
 are offlined or not when removing memory
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-3-git-send-email-tangchen@cn.fujitsu.com> <50DA6AB3.2030608@jp.fujitsu.com>
In-Reply-To: <50DA6AB3.2030608@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/27 11:11:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/27 11:11:40,
	Serialize complete at 2012/12/27 11:11:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 11:10 AM, Kamezawa Hiroyuki wrote:
> (2012/12/24 21:09), Tang Chen wrote:
>> From: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>>
>> We remove the memory like this:
>> 1. lock memory hotplug
>> 2. offline a memory block
>> 3. unlock memory hotplug
>> 4. repeat 1-3 to offline all memory blocks
>> 5. lock memory hotplug
>> 6. remove memory(TODO)
>> 7. unlock memory hotplug
>>
>> All memory blocks must be offlined before removing memory. But we don't hold
>> the lock in the whole operation. So we should check whether all memory blocks
>> are offlined before step6. Otherwise, kernel maybe panicked.
>>
>> Signed-off-by: Wen Congyang<wency@cn.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> 
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> 
> a nitpick below.
> 
>> +
>> +	for (pfn = start_pfn; pfn<  end_pfn; pfn += PAGES_PER_SECTION) {
> 
> I prefer adding mem = NULL at the start of this for().

Hi Kamezawa-san,

Added, thanks. :)

> 
>> +		section_nr = pfn_to_section_nr(pfn);
>> +		if (!present_section_nr(section_nr))
>> +			continue;
>> +
>> +		section = __nr_to_section(section_nr);
>> +		/* same memblock? */
>> +		if (mem)
>> +			if ((section_nr>= mem->start_section_nr)&&
>> +			    (section_nr<= mem->end_section_nr))
>> +				continue;
>> +
> 
> Thanks,
> -Kame
> 
> 
> 

