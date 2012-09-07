Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2IGHbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:31:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57203 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760263Ab2IGHam convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 7 Sep 2012 03:30:42 -0400
Message-Id: <5049BEF70200007800099965@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 08:31:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ix86: improve determination of
 X86_MINIMUM_CPU_FAMILY
References: <5049B4C102000078000998FE@nat28.tlf.novell.com>
 <50499F3C.1070706@zytor.com>
In-Reply-To: <50499F3C.1070706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.09.12 at 09:16, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 09/06/2012 11:48 PM, Jan Beulich wrote:
>>
>> --- 3.6-rc4/arch/x86/Kconfig.cpu
>> +++ 3.6-rc4-x86-minimum-cpu-family/arch/x86/Kconfig.cpu
>> @@ -409,9 +409,9 @@ config X86_CMOV
>>   config X86_MINIMUM_CPU_FAMILY
>>   	int
>>   	default "64" if X86_64
>> -	default "6" if X86_32 && X86_P6_NOP
>> -	default "5" if X86_32 && X86_CMPXCHG64
>> -	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
>> +	default "6" if X86_P6_NOP || X86_CMOV
>> +	default "5" if X86_CMPXCHG64 || X86_TSC
>> +	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK
>>   	default "3"
>>
> 
> Erk, this isn't right either.  We're not supposed to include 
> CPUID-enumerable features here, so X86_CMOV, X86_CMPXCHG64 and X86_TSC 
> don't belong, and should instead be done via required-features.h.

Ah, so I got misguided by there already being a CPUID-detectable
feature here (X86_CMPXCHG64). And by the fact that e.g. having
M686 (or better) selected is then in fact not expected to have a
relationship to the value chosen here (worth a comment perhaps).

Further, the "6" case is then completely pointless - X86_P6_NOP
depends on X86_64. And with all features the kernel cares about
that got added with Pentium and later being CPUID-enumerable,
the "5" case would then be superfluous too.

Jan

Jan

