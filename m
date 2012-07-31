Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2GaEdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:33:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53208 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2GaEdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:33:44 -0400
References: <1343688375.3696.597.camel@sbsiddha-desk.sc.intel.com> <20120731142049.7d0ab5f9@notabene.brown>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120731142049.7d0ab5f9@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] x86, avx: don't use avx instructions with "noxsave" boot param
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 30 Jul 2012 21:33:33 -0700
To: NeilBrown <neilb@suse.de>, Suresh Siddha <suresh.b.siddha@intel.com>
CC: james.t.kukunas@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Message-ID: <7b101443-b8d7-4474-ab54-03692d232469@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering if we shouldn't just kill the affected CPUID bits if osxsave is off...

NeilBrown <neilb@suse.de> wrote:

>On Mon, 30 Jul 2012 15:46:15 -0700 Suresh Siddha
><suresh.b.siddha@intel.com>
>wrote:
>
>> Check the kernel has indeed enabled xsave before using AVX
>instructions.
>> 
>> Fixes the kernel boot panic with "noxsave" boot parameter.
>> 
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
>Looks consistent with other usage - thanks.
>Applied.
>
>Should it go in '-stable' kernels too?
>
>NeilBrown
>
>> ---
>>  arch/x86/include/asm/xor_avx.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/xor_avx.h
>b/arch/x86/include/asm/xor_avx.h
>> index 2510d35..77987cd 100644
>> --- a/arch/x86/include/asm/xor_avx.h
>> +++ b/arch/x86/include/asm/xor_avx.h
>> @@ -197,12 +197,12 @@ static struct xor_block_template xor_block_avx
>= {
>>  
>>  #define AVX_XOR_SPEED \
>>  do { \
>> -	if (cpu_has_avx) \
>> +	if (cpu_has_avx && cpu_has_osxsave) \
>>  		xor_speed(&xor_block_avx); \
>>  } while (0)
>>  
>>  #define AVX_SELECT(FASTEST) \
>> -	(cpu_has_avx ? &xor_block_avx : FASTEST)
>> +	((cpu_has_avx && cpu_has_osxsave) ? &xor_block_avx : FASTEST)
>>  
>>  #else
>>  
>> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
