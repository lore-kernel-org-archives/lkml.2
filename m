Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1KPWJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:09:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51183 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1KPWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:09:15 -0500
Message-ID: <4EC43488.3070400@gmail.com>
Date: Wed, 16 Nov 2011 14:09:12 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
CC: David Daney <ddaney.cavm@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
References: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 01:32 PM, David Rientjes wrote:
> On Wed, 16 Nov 2011, David Daney wrote:
>
>> From: David Daney<david.daney@cavium.com>
>>
>> This is required now to get MIPS kernels to compile with
>> !CONFIG_HUGETLB_PAGE.
>>
>
> Why?

I should have been more specific.  The failure is in Ralf's 
mips-for-linux-next branch.

>  Apparently there's some config option you've enabled that is causing
> it to fail but I can't find it.  defconfig works fine on my mips
> crosscompiler and allyesconfig is borked already in other ways.

Please look in the mips-for-linux-next branch.

>
> This is definitely the wrong fix, anyway, and it would require a change to
> arch/mips/include/asm/page.h instead since it's localized to mips,

No, all we are doing is supplying a dummy definition for HPAGE_SHIFT as 
we currently have for HPAGE_SIZE and HPAGE_MASK.


> so nack.
>
>> Signed-off-by: David Daney<david.daney@cavium.com>
>> ---
>>   include/linux/hugetlb.h |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 19644e0..746d543 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -113,6 +113,7 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
>>   #ifndef HPAGE_MASK
>>   #define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
>>   #define HPAGE_SIZE	PAGE_SIZE

Why didn't you NACK the addition of these two lines too?

Following your logic, we should remove these and patch up all the 
architecture specific files instead.

David Daney

>> +#define HPAGE_SHIFT	PAGE_SHIFT
>>   #endif
>>
>>   #endif /* !CONFIG_HUGETLB_PAGE */
>

