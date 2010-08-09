Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0HIFPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:15:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60736 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0HIFPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o5X8c7KeO2Smtvje2x2bucOftwQlAQfzmMSkVYKcMegI3rqbE8VzmAV3Dfy9E1HRFz
         awb9VGL1qBlm1UeQOxsya1W5E8r9fMNeX7SoSt3uuUS+yQgzlWXv82YRB483246IxgzW
         DSgOxW1+SufVdujBVBY/9/NrPyHKMZvvnxa/w=
Message-ID: <4C5F8ED8.90301@gmail.com>
Date: Sun, 08 Aug 2010 22:15:04 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: remove RELOC_HIDE on __pa_symbol
References: <1281297456-2711-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281297456-2711-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/08/2010 12:57 PM, Namhyung Kim wrote:
> remove unneccessary use of RELOC_HIDE(). It does simple addition of ptr and
> offset and in this case (offset 0) does practically nothing. It does NOT do
> anything with linker relocation.
>

Maybe you could explain in more detail the problems you are having with 
the current definition of __pa_symbol().  I would be hesitant to change 
this bit of black magic unless there is a concrete problem you are 
trying to solve.

David Daney


> Signed-off-by: Namhyung Kim<namhyung@gmail.com>
> ---
>   arch/mips/include/asm/page.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
> index a16beaf..f7e2684 100644
> --- a/arch/mips/include/asm/page.h
> +++ b/arch/mips/include/asm/page.h
> @@ -150,7 +150,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
>       ((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
>   #endif
>   #define __va(x)		((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))
> -#define __pa_symbol(x)	__pa(RELOC_HIDE((unsigned long)(x), 0))
> +#define __pa_symbol(x)	__pa(x)
>
>   #define pfn_to_kaddr(pfn)	__va((pfn)<<  PAGE_SHIFT)
>

