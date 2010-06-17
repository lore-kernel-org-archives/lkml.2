Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0FQEWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:22:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab0FQEWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:22:38 -0400
Message-ID: <4C19A2EE.2010203@zytor.com>
Date: Wed, 16 Jun 2010 21:22:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org>
In-Reply-To: <20100617025052.GH9298@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 07:50 PM, Matthew Wilcox wrote:
> On Thu, Jun 17, 2010 at 10:30:06AM +0900, Kenji Kaneshige wrote:
>> Index: linux-2.6.34/arch/x86/mm/ioremap.c
>> ===================================================================
>> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-15 04:43:00.978332015 +0900
>> +++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-15 05:32:59.291693007 +0900
>> @@ -62,8 +62,8 @@
>>   static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>>   		unsigned long size, unsigned long prot_val, void *caller)
>>   {
>> -	unsigned long pfn, offset, vaddr;
>> -	resource_size_t last_addr;
>> +	unsigned long offset, vaddr;
>> +	resource_size_t pfn, last_pfn, last_addr;
>
> I have a hard time understanding this change.  pfn is always a physical
> address shifted by PAGE_SHIFT.  So a 32-bit pfn supports up to 44-bit
> physical addresses.  Are your addresses above 44-bits?
>

I think they might be.  Kenji?

	-hpa
