Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0DGXnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:43:52 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:59090 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab0DGXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:43:47 -0400
Message-ID: <4BBD17E9.1020509@oracle.com>
Date: Wed, 07 Apr 2010 16:40:25 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 25/33] x86, lmb: turn off ARCH_LMB_FIND_AREA
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>	 <1270001838-15857-26-git-send-email-yinghai@kernel.org> <1270683534.9521.8.camel@concordia>
In-Reply-To: <1270683534.9521.8.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBD1897.0063:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 04:38 PM, Michael Ellerman wrote:
> On Tue, 2010-03-30 at 19:17 -0700, Yinghai Lu wrote:
>> 32bit now can use generic __find_lmb_area now. So we can turn arch one off
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 1aa53ae..ce097ab 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -584,7 +584,7 @@ config PARAVIRT_DEBUG
>>  	  a paravirt_op is missing when it is called.
>>  
>>  config ARCH_LMB_FIND_AREA
>> -	default y
>> +	default n
>>  	bool "Use x86 own lmb_find_area()"
>>  	---help---
>>  	  Use lmb_find_area() version instead of generic version, it get free
> 
> So can't the whole ARCH_LMB_FIND_AREA go away then? And the generic
> version be made non-weak?

Later after more test, to make sure x86 could endure from high to low.
then we can remove ARCH_LMB_FIND_AREA.

YH
