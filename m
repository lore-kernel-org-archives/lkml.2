Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2BCKaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:30:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2BCKax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:30:53 -0500
Message-ID: <4F2BB715.8090803@mvista.com>
Date: Fri, 03 Feb 2012 14:29:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mips@linux-mips.org
Subject: Re: [Patch] mips: do not redefine BUILD_BUG()
References: <1328255503-17575-1-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1328255503-17575-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-02-2012 11:51, Cong Wang wrote:

> On mips, we got

> include/linux/kernel.h:717:1: error: "BUILD_BUG" redefined
> arch/mips/include/asm/page.h:43:1: error: this is the location of the previous definition
> make[3]: *** [arch/mips/sgi-ip27/ip27-console.o] Error 1
> make[2]: *** [arch/mips/sgi-ip27] Error 2
> make[1]: *** [arch/mips] Error 2
> make: *** [sub-make] Error 2

> use generic BUILD_BUG() instead of re-defining one.

> Signed-off-by: WANG Cong<xiyou.wangcong@gmail.com>

> ---
> diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
> index d417909..e14121a 100644
> --- a/arch/mips/include/asm/page.h
> +++ b/arch/mips/include/asm/page.h
> @@ -39,9 +39,7 @@
>   #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
>   #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
>   #else /* !CONFIG_HUGETLB_PAGE */
> -# ifndef BUILD_BUG

    Not clear why we get the error if we're protected with #ifndef...

> -#  define BUILD_BUG() do { extern void __build_bug(void); __build_bug(); } while (0)
> -# endif
> +#include<linux/kernel.h>

    Do not do #include among the #define's...

>   #define HPAGE_SHIFT	({BUILD_BUG(); 0; })
>   #define HPAGE_SIZE	({BUILD_BUG(); 0; })
>   #define HPAGE_MASK	({BUILD_BUG(); 0; })

WBR, Sergei
