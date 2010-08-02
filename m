Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0HBHz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:55:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57531 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab0HBHz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:55:56 -0400
Message-ID: <4C56790D.60504@cn.fujitsu.com>
Date: Mon, 02 Aug 2010 15:51:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: MMU: mark page dirty only when page is really
 written
References: <4C4E5313.1080308@cn.fujitsu.com> <4C4E536E.7030109@cn.fujitsu.com> <4C4E53F7.7050108@cn.fujitsu.com> <4C5678E3.8090309@redhat.com>
In-Reply-To: <4C5678E3.8090309@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
>  On 07/27/2010 06:35 AM, Xiao Guangrong wrote:
>> Mark page dirty only when this page is really written, it's more exacter,
>> and also can fix dirty page marking in speculation path
>>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/x86/kvm/mmu.c |   47
>> ++++++++++++++++++++++++++++-------------------
>>   1 files changed, 28 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index dd6c192..bcc2173 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -311,24 +311,42 @@ static bool spte_bits_lost(u64 spte)
>>       if (!is_shadow_present_pte(spte))
>>           return false;
>>
>> -    if (spte&  shadow_accessed_mask)
>> +    if (spte&  shadow_accessed_mask&&
>> +          (!is_writable_pte(spte) || spte&  shadow_dirty_mask))
>>           return false;
>>
> 
> Please add parentheses around bitwise operators to reduce confusion. 
> The rest looks good.
> 

OK, will do it in the new version, thanks.
