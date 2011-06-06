Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab1FFWdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:33:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634Ab1FFWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:32:59 -0400
Date: Mon, 6 Jun 2011 15:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-Id: <20110606153222.68dc2636.akpm@linux-foundation.org>
In-Reply-To: <20110603154554.GK2802@random.random>
References: <20110601175809.GB7306@suse.de>
	<20110601191529.GY19505@random.random>
	<20110601214018.GC7306@suse.de>
	<20110601233036.GZ19505@random.random>
	<20110602010352.GD7306@suse.de>
	<20110602132954.GC19505@random.random>
	<20110602145019.GG7306@suse.de>
	<20110602153754.GF19505@random.random>
	<20110603020920.GA26753@suse.de>
	<20110603144941.GI7306@suse.de>
	<20110603154554.GK2802@random.random>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 17:45:54 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Fri, Jun 03, 2011 at 03:49:41PM +0100, Mel Gorman wrote:
> > Right idea of the wrong zone being accounted for but wrong place. I
> > think the following patch should fix the problem;
> 
> Looks good thanks.
> 
> I also found this bug during my debugging that made NR_SHMEM underflow.
> 
> ===
> Subject: migrate: don't account swapcache as shmem
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> swapcache will reach the below code path in migrate_page_move_mapping,
> and swapcache is accounted as NR_FILE_PAGES but it's not accounted as
> NR_SHMEM.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index e4a5c91..2597a27 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -288,7 +288,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
>  	 */
>  	__dec_zone_page_state(page, NR_FILE_PAGES);
>  	__inc_zone_page_state(newpage, NR_FILE_PAGES);
> -	if (PageSwapBacked(page)) {
> +	if (mapping != &swapper_space && PageSwapBacked(page)) {
>  		__dec_zone_page_state(page, NR_SHMEM);
>  		__inc_zone_page_state(newpage, NR_SHMEM);
>  	}

fyi, this was the only patch I applied from this whole thread.  Once the
dust has settled, could people please resend whatever they have,
including any acked-by's and reviewed-by's?

Thanks.
