Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965567Ab0CORWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:22:51 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56659 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965538Ab0CORWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:22:49 -0400
Subject: Re: swiotlb detection should be memory hotplug aware ?
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <ak@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>
In-Reply-To: <4B9B01F5.3000807@linux.intel.com>
References: <1268446032.13691.69.camel@ank32>
	 <4B9B01F5.3000807@linux.intel.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 15 Mar 2010 10:22:49 -0700
Message-Id: <1268673769.28506.1.camel@ank32>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi, 

On Fri, 2010-03-12 at 19:09 -0800, Andi Kleen wrote:
> , Alok Kataria wrote:
> 
> Hi Alok,
> 
> > Hi,
> >
> > Looking at the current code swiotlb is initialized for 64bit kernels
> > only when the max_pfn value is greater than 4G (MAX_DMA32_PFN value).
> > So in cases when the initial memory is less than 4GB the kernel boots
> > without enabling swiotlb, when we hotadd memory to such a kernel and go
> > beyond the 4G limit, swiotlb is still disabled. As a result when any
> > 32bit devices start using this newly added memory beyond 4G, the kernel
> > starts spitting error messages like below or in some cases it causes
> > kernel panics.
> 
> Yes seems like a real problem.
> 
> >
> > 1. Enable swiotlb for all 64bit kernels which have memory hot-add
> > support.
> 
> I don't think that's a good idea. It would enable it everywhere on
> distributions which compile with hotadd. Need (2)
> 
> > 2. Instead of checking the max_pfn value in pci_swiotlb_detect, check
> > for max_hotpluggable_pfn (or some such) value. Though I don't see such a
> > value readily available. I could parse the SRAT and get hotplug memory
> > information but that will make swiotlb detection logic a little too
> > complex. A quick look around srat_xx.c files and the acpi_memhotplug
> > module didn't find any useful API that could be used directly either.
> > So was wondering if any of you are aware of an easy way to get such
> > information ?
> 
> I have a patchkit to revamp the SRAT parsing to store the hotadd information
> more efficiently (the current way is pretty dumb)  I need to repost that.

Can you please send me any pointers to that patch series. Also am just
curious to know about any merge plans for that patchkit.

Thanks,
Alok
> 
> With that it would be relatively easy to do I think.
> 
> -Andi

