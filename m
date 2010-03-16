Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937332Ab0CPBSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:18:30 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:35384 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937315Ab0CPBS1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 15 Mar 2010 21:18:27 -0400
Date: Mon, 15 Mar 2010 20:51:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: akataria@vmware.com, Len Brown <lenb@kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>
Subject: Re: [LKML] Re: swiotlb detection should be memory hotplug aware ?
Message-ID: <20100316005140.GB7622@phenom.dumpdata.com>
References: <1268446032.13691.69.camel@ank32> <4B9B01F5.3000807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9B01F5.3000807@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B9EDBFE.00DF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 07:09:41PM -0800, Andi Kleen wrote:
> , Alok Kataria wrote:
>
> Hi Alok,
>
>> Hi,
>>
>> Looking at the current code swiotlb is initialized for 64bit kernels
>> only when the max_pfn value is greater than 4G (MAX_DMA32_PFN value).
>> So in cases when the initial memory is less than 4GB the kernel boots
>> without enabling swiotlb, when we hotadd memory to such a kernel and go
>> beyond the 4G limit, swiotlb is still disabled. As a result when any
>> 32bit devices start using this newly added memory beyond 4G, the kernel
>> starts spitting error messages like below or in some cases it causes
>> kernel panics.
>
> Yes seems like a real problem.
>
>>
>> 1. Enable swiotlb for all 64bit kernels which have memory hot-add
>> support.
>
> I don't think that's a good idea. It would enable it everywhere on
> distributions which compile with hotadd. Need (2)
>
>> 2. Instead of checking the max_pfn value in pci_swiotlb_detect, check
>> for max_hotpluggable_pfn (or some such) value. Though I don't see such a
>> value readily available. I could parse the SRAT and get hotplug memory
>> information but that will make swiotlb detection logic a little too
>> complex. A quick look around srat_xx.c files and the acpi_memhotplug
>> module didn't find any useful API that could be used directly either.
>> So was wondering if any of you are aware of an easy way to get such
>> information ?
>
> I have a patchkit to revamp the SRAT parsing to store the hotadd information

There is a late mechanism to do kickoff the SWIOTLB. Perhaps the hot-add
could use swiotlb_init_late and start up the SWIOTLB?

> more efficiently (the current way is pretty dumb)  I need to repost that.
>
> With that it would be relatively easy to do I think.
>
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
