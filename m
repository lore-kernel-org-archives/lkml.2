Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2EKCTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:19:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59174 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab2EKCTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:19:30 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Minchan Kim" <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Marek Szyprowski" <m.szyprowski@samsung.com>
Subject: Re: [PATCH] cma: fix migration mode
References: <1336664003-5031-1-git-send-email-minchan@kernel.org>
Date: Thu, 10 May 2012 19:19:19 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wd4gqhfm3l0zgt@mpn-glaptop>
In-Reply-To: <1336664003-5031-1-git-send-email-minchan@kernel.org>
User-Agent: Opera Mail/11.62 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 08:33:23 -0700, Minchan Kim <minchan@kernel.org> wrote:
> __alloc_contig_migrate_range calls migrate_pages with wrong argument
> for migrate_mode. Fix it.
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4d926f1..9febc62 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5689,7 +5689,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
> 		ret = migrate_pages(&cc.migratepages,
>  				    __alloc_contig_migrate_alloc,
> -				    0, false, true);
> +				    0, false, MIGRATE_SYNC);
>  	}
> 	putback_lru_pages(&cc.migratepages);


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
