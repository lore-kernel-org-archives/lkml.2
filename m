Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2DQRMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:12:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49404 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2DQRMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120417155502.GE22687@tiehlicka.suse.cz>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
Date: Tue, 17 Apr 2012 10:12:30 -0700
X-Google-Sender-Auth: v9PfP_4rJO4z0nFsQ-er0sw1kWs
Message-ID: <CAE9FiQXWKzv7Wo4iWGrKapmxQYtAGezghwup1UKoW2ghqUSr+A@mail.gmail.com>
Subject: Re: Weirdness in __alloc_bootmem_node_high
From: Yinghai Lu <yinghai@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 8:55 AM, Michal Hocko <mhocko@suse.cz> wrote:
> Hi,
> I just come across the following condition in __alloc_bootmem_node_high
> which I have hard times to understand. I guess it is a bug and we need
> something like the following. But, to be honest, I have no idea why we
> care about those 128MB above MAX_DMA32_PFN.
> ---
>  mm/bootmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 0131170..5adb072 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -737,7 +737,7 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
>        /* update goal according ...MAX_DMA32_PFN */
>        end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
>
> -       if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
> +       if (end_pfn > MAX_DMA32_PFN + (128 << (20 - PAGE_SHIFT)) &&
>            (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
>                void *ptr;
>                unsigned long new_goal;
> --

We are not using bootmem with x86 now, so could remove those workaround now.

Thanks

Yinghai
