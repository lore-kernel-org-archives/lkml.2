Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1EIVOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:14:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab1EIVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:14:45 -0400
Date: Mon, 9 May 2011 14:13:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH]mm/migrate.c: clean up comment
Message-Id: <20110509141347.51ccc087.akpm@linux-foundation.org>
In-Reply-To: <1304697799.2450.9.camel@figo-desktop>
References: <1304697799.2450.9.camel@figo-desktop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 May 2011 00:03:11 +0800
"Figo.zhang" <figo1802@gmail.com> wrote:

> 
> clean up comment. prepare cgroup return 0 or -ENOMEN, others return -EAGAIN.
> avoid conflict meanings.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
> mm/migrate.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 34132f8..d65b351 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -647,7 +647,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  		if (unlikely(split_huge_page(page)))
>  			goto move_newpage;
>  
> -	/* prepare cgroup just returns 0 or -ENOMEM */
>  	rc = -EAGAIN;
>  
>  	if (!trylock_page(page)) {
> @@ -687,7 +686,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  		goto unlock;
>  	}
>  
> -	/* charge against new page */
> +	/* charge against new page, return 0 or -ENOMEM */
>  	charge = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
>  	if (charge == -ENOMEM) {
>  		rc = -ENOMEM;

Well it's still pretty confusing - the function can also return -EAGAIN
and -EBUSY, at least.

It would be better to remove this random sprinkle of commentlets and to
properly document unmap_and_move()'s interface in the usual fashion, in
its leading comment block.

