Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2LZDWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:22:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2LZDWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:22:01 -0500
X-IronPort-AV: E=Sophos;i="4.84,355,1355068800"; 
   d="scan'208";a="6474517"
Message-ID: <50DA6D1E.1010209@cn.fujitsu.com>
Date: Wed, 26 Dec 2012 11:21:02 +0800
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
Subject: Re: [PATCH v5 06/14] memory-hotplug: implement register_page_bootmem_info_section
 of sparse-vmemmap
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-7-git-send-email-tangchen@cn.fujitsu.com> <50D95F51.9090007@huawei.com>
In-Reply-To: <50D95F51.9090007@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 11:21:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 11:21:48
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 04:09 PM, Jianguo Wu wrote:
>> +
>> +		if (!cpu_has_pse) {
>> +			next = (addr + PAGE_SIZE)&  PAGE_MASK;
>> +			pmd = pmd_offset(pud, addr);
>> +			if (pmd_none(*pmd))
>> +				continue;
>> +			get_page_bootmem(section_nr, pmd_page(*pmd),
>> +					 MIX_SECTION_INFO);
>> +
>> +			pte = pte_offset_kernel(pmd, addr);
>> +			if (pte_none(*pte))
>> +				continue;
>> +			get_page_bootmem(section_nr, pte_page(*pte),
>> +					 SECTION_INFO);
>> +		} else {
>> +			next = pmd_addr_end(addr, end);
>> +
>> +			pmd = pmd_offset(pud, addr);
>> +			if (pmd_none(*pmd))
>> +				continue;
>> +			get_page_bootmem(section_nr, pmd_page(*pmd),
>> +					 SECTION_INFO);
>
> Hi Tang，
> 	In this case, pmd maps 512 pages, but you only get_page_bootmem() on the first page.
> I think the whole 512 pages should be get_page_bootmem(), what do you think?
>
Hi Wu,

Yes, thanks. I will fix it. :)

Thanks. :)

