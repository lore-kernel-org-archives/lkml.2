Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2ICFZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:25:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2ICFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:25:31 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-5-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-5-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:25:30 +0300
X-Google-Sender-Auth: 3VLbRn1sQHePmmQxhWf45FE6cSE
Message-ID: <CAOJsxLEnOrODp9DA0tZpbHrnO7wCmVa_xuzkobDGN-i=U1NVFA@mail.gmail.com>
Subject: Re: [PATCH -v2 04/13] x86, mm: Revert back good_end setting for 64bit
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> So we could put page table high again for 64bit.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

The changelog for this is too terse for me to actually understand why
this is needed.

> ---
>  arch/x86/mm/init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 15a6a38..cca9b7d 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -76,8 +76,8 @@ static void __init find_early_table_space(struct map_range *mr,
>  #ifdef CONFIG_X86_32
>         /* for fixmap */
>         tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> -#endif
>         good_end = max_pfn_mapped << PAGE_SHIFT;
> +#endif
>
>         base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
>         if (!base)
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
