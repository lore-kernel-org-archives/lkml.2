Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1EYRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:09:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62927 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1EYRJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:09:57 -0400
Message-ID: <4DDD37B7.7000101@oracle.com>
Date: Wed, 25 May 2011 10:09:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/4] include/linux/printk.h is not self-contained
References: <1306314554-19198-1-git-send-email-y>
In-Reply-To: <1306314554-19198-1-git-send-email-y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DDD37C2.008E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/11 02:09, y@mail.of.borg wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> <linux/printk.h> needs to include
>   - <stdarg.h> for "va_list",
>   - <linux/linkage.h> for "asmlinkage",
>   - <linux/types.h> for "bool".
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/linux/printk.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index ee048e7..6388bc8 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -1,6 +1,10 @@
>  #ifndef __KERNEL_PRINTK__
>  #define __KERNEL_PRINTK__
>  
> +#include <stdarg.h>
> +#include <linux/linkage.h>
> +#include <linux/types.h>
> +
>  extern const char linux_banner[];
>  extern const char linux_proc_banner[];
>  

I agree with this patch along with Joe's 2 header additions...
but I get build errors with it (as reported yesterday):


  CC      arch/x86/kernel/asm-offsets.s
In file included from linux-next-20110524/include/linux/thread_info.h:53,
                 from linux-next-20110524/include/linux/preempt.h:9,
                 from linux-next-20110524/include/linux/spinlock.h:50,
                 from linux-next-20110524/include/linux/ratelimit.h:5,
                 from linux-next-20110524/include/linux/printk.h:8,
                 from linux-next-20110524/include/linux/kernel.h:20,
                 from linux-next-20110524/arch/x86/include/asm/percpu.h:44,
                 from linux-next-20110524/arch/x86/include/asm/current.h:5,
                 from linux-next-20110524/arch/x86/include/asm/processor.h:15,
                 from linux-next-20110524/arch/x86/include/asm/atomic.h:6,
                 from linux-next-20110524/include/linux/crypto.h:20,
                 from linux-next-20110524/arch/x86/kernel/asm-offsets.c:8:
linux-next-20110524/arch/x86/include/asm/thread_info.h:34: error: expected specifier-qualifier-list before 'mm_segment_t'
In file included from linux-next-20110524/include/linux/ratelimit.h:5,
                 from linux-next-20110524/include/linux/printk.h:8,
                 from linux-next-20110524/include/linux/kernel.h:20,
                 from linux-next-20110524/arch/x86/include/asm/percpu.h:44,
                 from linux-next-20110524/arch/x86/include/asm/current.h:5,
                 from linux-next-20110524/arch/x86/include/asm/processor.h:15,
                 from linux-next-20110524/arch/x86/include/asm/atomic.h:6,
                 from linux-next-20110524/include/linux/crypto.h:20,
                 from linux-next-20110524/arch/x86/kernel/asm-offsets.c:8:
linux-next-20110524/include/linux/spinlock.h: In function 'spin_unlock_wait':
linux-next-20110524/include/linux/spinlock.h:360: error: implicit declaration of function 'cpu_relax'
In file included from linux-next-20110524/arch/x86/include/asm/atomic.h:6,
                 from linux-next-20110524/include/linux/crypto.h:20,
                 from linux-next-20110524/arch/x86/kernel/asm-offsets.c:8:
linux-next-20110524/arch/x86/include/asm/processor.h: At top level:
linux-next-20110524/arch/x86/include/asm/processor.h:707: warning: conflicting types for 'cpu_relax'
linux-next-20110524/arch/x86/include/asm/processor.h:707: error: static declaration of 'cpu_relax' follows non-static declaration
linux-next-20110524/include/linux/spinlock.h:360: note: previous implicit declaration of 'cpu_relax' was here
In file included from linux-next-20110524/arch/x86/include/asm/i387.h:17,
                 from linux-next-20110524/arch/x86/include/asm/suspend_32.h:10,
                 from linux-next-20110524/arch/x86/include/asm/suspend.h:2,
                 from linux-next-20110524/arch/x86/kernel/asm-offsets.c:18:
linux-next-20110524/include/linux/regset.h: In function 'copy_regset_to_user':
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h: In function 'copy_regset_from_user':
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
linux-next-20110524/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
In file included from linux-next-20110524/arch/x86/kernel/asm-offsets.c:25:
linux-next-20110524/arch/x86/kernel/asm-offsets_32.c: In function 'foo':
linux-next-20110524/arch/x86/kernel/asm-offsets_32.c:32: error: 'struct thread_info' has no member named 'sysenter_return'
linux-next-20110524/arch/x86/kernel/asm-offsets.c: In function 'common':
linux-next-20110524/arch/x86/kernel/asm-offsets.c:34: error: 'struct thread_info' has no member named 'addr_limit'

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
