Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2JDVIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:08:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55847 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2JDVIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:08:49 -0400
Message-ID: <506DFAD8.5060701@zytor.com>
Date: Thu, 04 Oct 2012 14:08:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Beulich <jbeulich@suse.com>
CC: matt@console-pimps.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, mingo@kernel.org, x86@kernel.org,
        mjg@redhat.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map in
 trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org> <1349269157-25956-2-git-send-email-matt@console-pimps.org> <506C4C3A020000780008D041@nat28.tlf.novell.com>
In-Reply-To: <506C4C3A020000780008D041@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 06:31 AM, Jan Beulich wrote:
>>>> Matt Fleming <matt@console-pimps.org> 10/03/12 2:59 PM >>>
>> +static int insert_identity_mapping(resource_size_t paddr, unsigned long vaddr,
>> +                    unsigned long size)
>> +{
>> +    unsigned long end = vaddr + size;
>> +    unsigned long next;
>> +    pgd_t *vpgd, *ppgd;
>> +
>> +#ifdef CONFIG_X86_32
>> +    ppgd = initial_page_table + pgd_index(paddr);
>> +
>> +    if (paddr >= PAGE_OFFSET || paddr + size > PAGE_OFFSET)
>> +        return 1;
>> +#else
>> +    ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);
>
> Missing equivalent code (to the 32-bit one above) here - after all, you're trying
> to potentially insert a 52-bit physical address into 48-bit virtual space.
>

We should have the check, but at least for Linux support we require
P <= V-2.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

