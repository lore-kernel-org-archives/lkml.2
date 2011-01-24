Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1AXTdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:33:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53544 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1AXTdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:33:03 -0500
Message-ID: <4D3DD366.8000704@mvista.com>
Date: Mon, 24 Jan 2011 22:30:46 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Yoichi Yuasa <yuasa@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error when CONFIG_SWAP is not set
References: <20110124210813.ba743fc5.yuasa@linux-mips.org>
In-Reply-To: <20110124210813.ba743fc5.yuasa@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Yoichi Yuasa wrote:

> In file included from
> linux-2.6/arch/mips/include/asm/tlb.h:21,
>                  from mm/pgtable-generic.c:9:
> include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> include/asm-generic/tlb.h:76: error: implicit declaration of function
> 'release_pages'
> include/asm-generic/tlb.h: In function 'tlb_remove_page':
> include/asm-generic/tlb.h:105: error: implicit declaration of function
> 'page_cache_release'
> make[1]: *** [mm/pgtable-generic.o] Error 1
> 
> Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
[...]

> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4d55932..92c1be6 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -8,6 +8,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/sched.h>
>  #include <linux/node.h>
> +#include <linux/pagemap.h>

    Hm, if the errors are in <asm-generic/tlb.h>, why add #include in 
<linux/swap.h>?

WBR. Sergei
