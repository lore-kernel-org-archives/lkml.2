Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1B1Qmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:42:33 -0500
Received: from xenotime.net ([184.105.210.51]:41036 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756025Ab1B1Qmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:42:31 -0500
Date: Mon, 28 Feb 2011 08:42:22 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Thomas Gleixner (maintainer:X86 ARCHITECTURE...) 
	<tglx@linutronix.de>,
        Ingo Molnar (maintainer:X86 ARCHITECTURE...) <mingo@redhat.com>,
        "H. Peter Anvin" (maintainer:X86 ARCHITECTURE...) <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Subject: Re: [PATCH] fix mmap random address range on x86 (try2)
Message-Id: <20110228084222.eb52e7c4.rdunlap@xenotime.net>
In-Reply-To: <1298904783-4291-1-git-send-email-ludwig.nussel@suse.de>
References: <1298904783-4291-1-git-send-email-ludwig.nussel@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 15:53:03 +0100 Ludwig Nussel wrote:

> On x86 casting the unsigned int result of get_random_int() to long
> may result in a negative value. On x86 the range of mmap_rnd()
> therefore was -255 to 255. The 32bit mode on x86_64 used 0 to 255 as
> intended.
> 
> The bug was introduced by commit 675a081 in January 2008.
> 
> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
> ---
>  arch/x86/mm/mmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 1dab519..f927429 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -87,9 +87,9 @@ static unsigned long mmap_rnd(void)
>  	*/
>  	if (current->flags & PF_RANDOMIZE) {
>  		if (mmap_is_ia32())
> -			rnd = (long)get_random_int() % (1<<8);
> +			rnd = get_random_int() % (1<<8);
>  		else
> -			rnd = (long)(get_random_int() % (1<<28));
> +			rnd = get_random_int() % (1<<28);
>  	}
>  	return rnd << PAGE_SHIFT;
>  }
> -- 

Is there a test case for this?
Can it be tested/checked/observed?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
