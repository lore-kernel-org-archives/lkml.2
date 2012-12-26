Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2LZDE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:04:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63712 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2LZDEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:04:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,355,1355068800"; 
   d="scan'208";a="6474349"
Message-ID: <50DA65B7.2050707@cn.fujitsu.com>
Date: Wed, 26 Dec 2012 10:49:27 +0800
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
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-9-git-send-email-tangchen@cn.fujitsu.com> <50D96116.1070305@huawei.com>
In-Reply-To: <50D96116.1070305@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 10:50:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 11:03:57,
	Serialize complete at 2012/12/26 11:03:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 04:17 PM, Jianguo Wu wrote:
>> +
>> +static void __meminit free_pagetable(struct page *page, int order)
>> +{
>> +	struct zone *zone;
>> +	bool bootmem = false;
>> +	unsigned long magic;
>> +
>> +	/* bootmem page has reserved flag */
>> +	if (PageReserved(page)) {
>> +		__ClearPageReserved(page);
>> +		bootmem = true;
>> +
>> +		magic = (unsigned long)page->lru.next;
>> +		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO)
>> +			put_page_bootmem(page);
>
> Hi Tang,
>
> For removing memmap of sparse-vmemmap, in cpu_has_pse case, if magic == SECTION_INFO,
> the order will be get_order(PMD_SIZE), so we need a loop here to put all the 512 pages.
>
Hi Wu,

Thanks for reminding me that. I truely missed it.

And since in register_page_bootmem_info_section(), a whole memory
section will be set as SECTION_INFO, I think we don't need to check
the page magic one by one, just the first one is enough. :)

I will fix it, thanks. :)

