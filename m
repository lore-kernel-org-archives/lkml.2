Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2BHQmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:42:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45610 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2BHQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:42:22 -0500
Message-ID: <4F32A55E.8010401@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 08:39:58 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com> <4F21A5AF.6010605@linux.vnet.ibm.com> <4F300D41.5050105@linux.vnet.ibm.com>
In-Reply-To: <4F300D41.5050105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020816-7282-0000-0000-00000653D252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 09:26 AM, Seth Jennings wrote:
> On 01/26/2012 01:12 PM, Dave Hansen wrote:
>> void *kmap_atomic_prot(struct page *page, pgprot_t prot)
>> {
>> ...
>>         type = kmap_atomic_idx_push();
>>         idx = type + KM_TYPE_NR*smp_processor_id();
>>         vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>>
>> I think if you do a get_cpu()/put_cpu() or just a preempt_disable()
>> across the operations you'll be guaranteed to get two contiguous addresses.
> 
> I'm not quite following here.  kmap_atomic() only does this for highmem pages.
> For normal pages (all pages for 64-bit), it doesn't do any mapping at all.  It
> just returns the virtual address of the page since it is in the kernel's address
> space.
> 
> For this design, the pages _must_ be mapped, even if the pages are directly
> reachable in the address space, because they must be virtually contiguous.

I guess you could use vmap() for that.  It's just going to be slower
than kmap_atomic().  I'm really not sure it's worth all the trouble to
avoid order-1 allocations, though.

