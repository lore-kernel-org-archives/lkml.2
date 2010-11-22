Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0KVQVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:21:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35434 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0KVQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:21:22 -0500
Message-ID: <4CEA983A.5000200@oracle.com>
Date: Mon, 22 Nov 2010 08:20:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc3 (fixmap build error)
References: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>	<20101121181655.4996cdde.randy.dunlap@oracle.com>	<AANLkTi=4scuTeRyr1WuGbzk2jKdU_Ugu61ABoXPuXnVK@mail.gmail.com> <20101121214450.62fac5a4.akpm@linux-foundation.org>
In-Reply-To: <20101121214450.62fac5a4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/10 21:44, Andrew Morton wrote:
> On Sun, 21 Nov 2010 20:33:07 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Sun, Nov 21, 2010 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>> I thought that I saw a patch for this one, but I can't find it now.
>>>
>>> on i386:
>>> arch/x86/built-in.o: In function `fix_to_virt':
>>> /usr/builds/linux-2.6.37-rc3/arch/x86/include/asm/fixmap.h:207: undefined reference to `__this_fixmap_does_not_exist'
>>
>> Hmm. Does it help to mark __set_fixmap_offset() as "__always_inline"
>> rather than just "inline"?
> 
> yup.

yep.  Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> 
> Subject: arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> When compiling arch/x86/kernel/early_printk_mrst.c with i386 allmodconfig,
> gcc-4.1.0 generates an out-of-line copy of __set_fixmap_offset() which
> contains a reference to __this_fixmap_does_not_exist which the compiler cannot
> elide.
> 
> Marking __set_fixmap_offset() as __always_inline prevents this.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/include/asm/fixmap.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN arch/x86/kernel/early_printk_mrst.c~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/kernel/early_printk_mrst.c
> diff -puN arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/include/asm/fixmap.h
> --- a/arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline
> +++ a/arch/x86/include/asm/fixmap.h
> @@ -220,8 +220,8 @@ static inline unsigned long virt_to_fix(
>  }
>  
>  /* Return an pointer with offset calculated */
> -static inline unsigned long __set_fixmap_offset(enum fixed_addresses idx,
> -				phys_addr_t phys, pgprot_t flags)
> +static __always_inline unsigned long
> +__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
>  {
>  	__set_fixmap(idx, phys, flags);
>  	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
> _
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
