Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0EINhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 09:37:42 -0400
Received: from amanaus.varma-el.com ([194.186.189.102]:39314 "EHLO
	amanaus.varma-el.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0EINhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 09:37:38 -0400
Message-ID: <4BE6BA7D.7030700@varma-el.com>
Date: Sun, 09 May 2010 17:37:01 +0400
From: Andrey Volkov <avolkov@varma-el.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: linuxppc-dev list <Linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, David Gibson <dwg@au1.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>, benh@kernel.crashing.org
Subject: Re: Fix [e]glibc build process
References: <4BE5C203.6060509@varma-el.com> <1273375269.5312.4.camel@norville.austin.ibm.com>
In-Reply-To: <1273375269.5312.4.camel@norville.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> On Sat, 2010-05-08 at 23:56 +0400, Andrey Volkov wrote:
>   
>> This patch fix [e]glibc build process destruction (more precisely _assembler_
>> is die when try to compile getcontext.S since stdint.h coldn't be assembled)
>> intruduced by patch:
>>
>> commit: 162d92dfb79a0b5fc03380b8819fa5f870ebf1e
>> Date: Mon, 8 Feb 2010 11:51:05 +0000 (11:51 +0000)
>> from: Dave Kleikamp
>>
>> Signed-off-by: Andrey Volkov <avolkov@varma-el.com>
>>
>> ---
>>
>>  arch/powerpc/include/asm/ptrace.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>>
>> diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
>> index 9e2d84c..025912b 100644
>> --- a/arch/powerpc/include/asm/ptrace.h
>> +++ b/arch/powerpc/include/asm/ptrace.h
>> @@ -27,8 +27,10 @@
>>  #ifdef __KERNEL__
>>  #include <linux/types.h>
>>  #else
>> +#ifndef __ASSEMBLY__
>>  #include <stdint.h>
>>  #endif
>> +#endif
>>
>>  #ifndef __ASSEMBLY__
>>     
>
> Assembly code won't need to pull in linux/types.h either, so this would
> be simpler:
>   
Questionable assertion. "linux/types.h" contain (indirectly) not only 
types definitions, but some useful, for assembly, defines too.
So patch, which Sam Ravnborg offered, is better for me (if it will work 
certainly ;)).

--
Andrey Volkov

> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>
> diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
> index 9e2d84c..0ed710e 100644
> --- a/arch/powerpc/include/asm/ptrace.h
> +++ b/arch/powerpc/include/asm/ptrace.h
> @@ -24,14 +24,14 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  
> +#ifndef __ASSEMBLY__
> +
>  #ifdef __KERNEL__
>  #include <linux/types.h>
>  #else
>  #include <stdint.h>
>  #endif
>  
> -#ifndef __ASSEMBLY__
> -
>  struct pt_regs {
>  	unsigned long gpr[32];
>  	unsigned long nip;
>
>   

