Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0IEPlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 11:41:14 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18695 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0IEPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:41:13 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2dK1432N98dN9371Pzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8A60R-02-53X-02
X-M-MSG: 
Message-ID: <4C83B939.60005@amd.com>
Date: Sun, 5 Sep 2010 17:37:29 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: Fix misnamed AMD CPUID feature bit
References: <1283506069-1096-1-git-send-email-andre.przywara@amd.com> <1283506069-1096-2-git-send-email-andre.przywara@amd.com> <4C834FCA.4020207@redhat.com>
In-Reply-To: <4C834FCA.4020207@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>   On 09/03/2010 12:27 PM, Andre Przywara wrote:
>> The AMD SSE5 feature set as-it has been replaced by some extensions
>> to the AVX instruction set. Thus the bit formerly advertised as SSE5
>> is re-used for one of these extensions (XOP).
>> Although this changes the /proc/cpuinfo output, it is not user visible, as
>> there are no CPUs (yet) having this feature.
>> To avoid confusion this should be added to the stable series, too.
>>
>>
>>
>> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
>> index 781a50b..c9c73d8 100644
>> --- a/arch/x86/include/asm/cpufeature.h
>> +++ b/arch/x86/include/asm/cpufeature.h
>> @@ -152,7 +152,7 @@
>>   #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
>>   #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
>>   #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
>> -#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
>> +#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
>>   #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
>>   #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
>>   #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
> 
> Even with the -stable update, there may be distributions which have 
> kernels with the old name.  That means userspace would need to look for 
> both names if it wants to be sure.
CPUs having XOP will not be available before next year, and since XOP is 
using the same register set as AVX, it cannot be used without proper 
XSAVE/XRESTORE support. I am not sure when exactly XSAVE was introduced 
in the kernel, but I think this limits the usability of older kernels 
for XOP.
I see that there is a faint possibility of causing trouble, but I don't 
see any real alternative.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

