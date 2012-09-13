Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2IMTRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:17:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44366 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2IMTRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <1347324112-14134-1-git-send-email-minchan@kernel.org>
References: <1347324112-14134-1-git-send-email-minchan@kernel.org>
Date: Thu, 13 Sep 2012 21:17:19 +0200
X-Google-Sender-Auth: 4dU2wCjpHBwqCbwSXUxh-LPKYwc
Message-ID: <CAMuHMdXWZ=Jeggd7cT_LXK0MTnmFAf+cWEhC75B1gCcSd3eWeg@mail.gmail.com>
Subject: Re: [PATCH] mm: cma: Discard clean pages during contiguous allocation
 instead of migration
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Kyungmin Park <kmpark@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 2:41 AM, Minchan Kim <minchan@kernel.org> wrote:
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -674,8 +674,10 @@ static enum page_references page_check_references(struct page *page,
>  static unsigned long shrink_page_list(struct list_head *page_list,
>                                       struct zone *zone,
>                                       struct scan_control *sc,
> +                                     enum ttu_flags ttu_flags,

"enum ttu_flags" is defined on CONFIG_MMU=y only, causing on nommu:

mm/vmscan.c:677:26: error: parameter 4 ('ttu_flags') has incomplete type
mm/vmscan.c:987:5: error: 'TTU_UNMAP' undeclared (first use in this function)
mm/vmscan.c:987:15: error: 'TTU_IGNORE_ACCESS' undeclared (first use
in this function)
mm/vmscan.c:1312:56: error: 'TTU_UNMAP' undeclared (first use in this function)

E.g.
http://kisskb.ellerman.id.au/kisskb/buildresult/7191694/ (h8300-defconfig)
http://kisskb.ellerman.id.au/kisskb/buildresult/7191858/ (sh-allnoconfig)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
