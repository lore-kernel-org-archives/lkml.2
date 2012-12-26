Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2LZDMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:12:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab2LZDL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:11:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,355,1355068800"; 
   d="scan'208";a="6474423"
Message-ID: <50DA6AC5.4020904@cn.fujitsu.com>
Date: Wed, 26 Dec 2012 11:11:01 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: akpm@linux-foundation.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 08/14] memory-hotplug: Common APIs to support page
 tables hot-remove
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-9-git-send-email-tangchen@cn.fujitsu.com> <50D96116.1070305@huawei.com> <50DA65B7.2050707@cn.fujitsu.com>
In-Reply-To: <50DA65B7.2050707@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 11:11:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 11:11:47,
	Serialize complete at 2012/12/26 11:11:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 10:49 AM, Tang Chen wrote:
> On 12/25/2012 04:17 PM, Jianguo Wu wrote:
>>> +
>>> +static void __meminit free_pagetable(struct page *page, int order)
>>> +{
>>> + struct zone *zone;
>>> + bool bootmem = false;
>>> + unsigned long magic;
>>> +
>>> + /* bootmem page has reserved flag */
>>> + if (PageReserved(page)) {
>>> + __ClearPageReserved(page);
>>> + bootmem = true;
>>> +
>>> + magic = (unsigned long)page->lru.next;
>>> + if (magic == SECTION_INFO || magic == MIX_SECTION_INFO)

And also, I think we don't need to check MIX_SECTION_INFO since it is
for the pageblock_flags, not the memmap in the section.

Thanks. :)

>>> + put_page_bootmem(page);
>>
>> Hi Tang,
>>
>> For removing memmap of sparse-vmemmap, in cpu_has_pse case, if magic
>> == SECTION_INFO,
>> the order will be get_order(PMD_SIZE), so we need a loop here to put
>> all the 512 pages.
>>
> Hi Wu,
>
> Thanks for reminding me that. I truely missed it.
>
> And since in register_page_bootmem_info_section(), a whole memory
> section will be set as SECTION_INFO, I think we don't need to check
> the page magic one by one, just the first one is enough. :)
>
> I will fix it, thanks. :)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

