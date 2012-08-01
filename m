Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2HAGE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 02:04:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2HAGE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 02:04:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,691,1336320000"; 
   d="scan'208";a="5526158"
Message-ID: <5018C817.80509@cn.fujitsu.com>
Date: Wed, 01 Aug 2012 14:09:27 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: gerald.schaefer@de.ibm.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 16/19] memory-hotplug: free memmap of sparse-vmemmap
References: <50126B83.3050201@cn.fujitsu.com>	<50126EBE.1020006@cn.fujitsu.com> <20120731142251.5b2cae37@thinkpad>
In-Reply-To: <20120731142251.5b2cae37@thinkpad>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/01 14:04:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/01 14:04:56,
	Serialize complete at 2012/08/01 14:04:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/31/2012 08:22 PM, Gerald Schaefer Wrote:
> On Fri, 27 Jul 2012 18:34:38 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> All pages of virtual mapping in removed memory cannot be freed, since
>> some pages used as PGD/PUD includes not only removed memory but also
>> other memory. So the patch checks whether page can be freed or not.
>>
>> How to check whether page can be freed or not?
>>  1. When removing memory, the page structs of the revmoved memory are
>> filled with 0FD.
>>  2. All page structs are filled with 0xFD on PT/PMD, PT/PMD can be
>> cleared. In this case, the page used as PT/PMD can be freed.
>>
>> Applying patch, __remove_section() of CONFIG_SPARSEMEM_VMEMMAP is
>> integrated into one. So __remove_section() of
>> CONFIG_SPARSEMEM_VMEMMAP is deleted.
> 
> There should also be generic or dummy versions of the functions
> vmemmap_free_bootmem(), vmemmap_kfree() and
> register_page_bootmem_memmap(). It doesn't compile on other
> archtitectures than x86 as it is now:
> 
> mm/built-in.o: In function `sparse_remove_one_section':
> (.text+0x49fa6): undefined reference to `vmemmap_free_bootmem'
> mm/built-in.o: In function `sparse_remove_one_section':
> (.text+0x49fcc): undefined reference to `vmemmap_kfree'
> mm/built-in.o: In function `register_page_bootmem_info_node':
> (.text+0x57c06): undefined reference to `register_page_bootmem_memmap'
> mm/built-in.o: In function `sparse_add_one_section':
> (.meminit.text+0x2506): undefined reference to `vmemmap_kfree'
> mm/built-in.o: In function `sparse_add_one_section':
> (.meminit.text+0x2528): undefined reference to `vmemmap_kfree'
> make: *** [vmlinux] Error 1
> 
> 

Thanks for testing. I will fix it.

Wen Congyang
