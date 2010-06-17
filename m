Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0FQGV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:21:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47021 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab0FQGV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:21:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C19BED5.4090801@jp.fujitsu.com>
Date: Thu, 17 Jun 2010 15:21:09 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com> <4C19BA9A.4010300@zytor.com>
In-Reply-To: <4C19BA9A.4010300@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/17 15:03), H. Peter Anvin wrote:
> On 06/16/2010 09:55 PM, Kenji Kaneshige wrote:
>>>
>>> I think they might be. Kenji?
>>
>> No. My addresses are in the 44-bits range (around fc000000000). So it is
>> not required for my problem. This change assumes that phys_addr can be
>> above 44-bits (up to 52-bits (and higher in the future?)).
>>
>> By the way, is there linux kernel limit regarding above 44-bits physical
>> address in x86_32 PAE? For example, pfn above 32-bits is not supported?
>>
>
> There are probably places at which PFNs are held in 32-bit numbers,
> although it would be good to track them down if it isn't too expensive
> to fix them (i.e. doesn't affect generic code.)
>
> This also affects paravirt systems, i.e. right now Xen has to locate all
> 32-bit guests below 64 GB, which limits its usefulness.
>
>> #ifdef CONFIG_X86_PAE
>> /* 44=32+12, the limit we can fit into an unsigned long pfn */
>> #define __PHYSICAL_MASK_SHIFT   44
>> #define __VIRTUAL_MASK_SHIFT    32
>>
>> If there is 44-bits physical address limit, I think it's better to use
>> PHYSICAL_PAGE_MASK for masking physical address, instead of "(phys_addr
>>>> PAGE_SHIFT)<<  PAGE_SHIFT)". The PHYSICAL_PAGE_MASK would become
>> greater value when 44-bits physical address limit is eliminated. And
>> maybe we need to change phys_addr_valid() returns error if physical
>> address is above (1<<  __PHYSICAL_MASK_SHIFT)?
>
> The real question is how much we can fix without an unreasonable cost.
>

Thank you very much. I understand the situation.

Thanks,
Kenji Kaneshige


