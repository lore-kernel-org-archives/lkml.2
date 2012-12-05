Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2LECIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:08:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab2LECIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:08:36 -0500
X-IronPort-AV: E=Sophos;i="4.83,374,1352044800"; 
   d="scan'208";a="6333615"
Message-ID: <50BEAC66.8020500@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 10:07:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>, benh@kernel.crashing.org,
        paulus@samba.org, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [Patch v4 08/12] memory-hotplug: remove memmap of sparse-vmemmap
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com> <1354010422-19648-9-git-send-email-wency@cn.fujitsu.com> <50B5DC00.20103@huawei.com> <50B80FB1.6040906@cn.fujitsu.com> <50BC0D2D.8040008@huawei.com> <50BDBEB7.3070807@cn.fujitsu.com> <50BDEA82.4050809@huawei.com>
In-Reply-To: <50BDEA82.4050809@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/05 10:07:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/05 10:07:55,
	Serialize complete at 2012/12/05 10:07:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On 12/04/2012 08:20 PM, Jianguo Wu wrote:
(snip)
>>
>> Seems that we have different ways to handle pages allocated by bootmem
>> or by regular allocator. Is the checking way in [PATCH 09/12] available
>> here ?
>>
>> +    /* bootmem page has reserved flag */
>> +    if (PageReserved(page)) {
>> ......
>> +    }
>>
>> If so, I think we can just merge these two functions.
>
> Hmm, direct mapping table isn't allocated by bootmem allocator such as memblock, can't be free by put_page_bootmem().
> But I will try to merge these two functions.
>

Oh, I didn't notice this, thanks. :)

(snip)

>>> +
>>> +    __split_large_page(kpte, address, pbase);
>>
>> Is this patch going to replace [PATCH 08/12] ?
>>
>
> I wish to replace [PATCH 08/12], but need Congyang and Yasuaki to confirm first:)
>
>> If so, __split_large_page() was added and exported in [PATCH 09/12],
>> then we should move it here, right ?
>
> yes.
>
> and what do you think about moving vmemmap_pud[pmd/pte]_remove() to arch/x86/mm/init_64.c,
> to be consistent with vmemmap_populate() ?

It is a good idea since pud/pmd/pte related code could be platform
dependent. And I'm also trying to move vmemmap_free() to
arch/x86/mm/init_64.c too. I want to have a common interface just
like vmemmap_populate(). :)

>
> I will rework [PATCH 08/12] and [PATCH 09/12] soon.

I am rebasing the whole patch set now. And I think I chould finish part
of your work too. A new patch-set is coming soon, and your rework is
also welcome. :)

Thanks. :)


