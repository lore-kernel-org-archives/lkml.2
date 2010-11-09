Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0KIAHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 19:07:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab0KIAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 19:07:09 -0500
Date: Mon, 8 Nov 2010 16:05:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, arunabal@in.ibm.com,
        sbest@us.ibm.com, stable <stable@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v2][PATCH] [v2] Revalidate page->mapping in
 do_generic_file_read()
Message-Id: <20101108160555.2925ea57.akpm@linux-foundation.org>
In-Reply-To: <20101105211615.2D67A348@kernel.beaverton.ibm.com>
References: <20101105211615.2D67A348@kernel.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Nov 2010 14:16:15 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> --- linux-2.6.git/mm/filemap.c~is_partially_uptodate-revalidate-page	2010-11-03 13:49:21.000000000 -0700
> +++ linux-2.6.git-dave/mm/filemap.c	2010-11-04 06:59:08.000000000 -0700
> @@ -1016,6 +1016,9 @@ find_page:
>  				goto page_not_up_to_date;
>  			if (!trylock_page(page))
>  				goto page_not_up_to_date;
> +			/* Did it get truncated before we got the lock? */
> +			if (!page->mapping)
> +				goto page_not_up_to_date_locked;
>  			if (!mapping->a_ops->is_partially_uptodate(page,
>  								desc, offset))
>  				goto page_not_up_to_date_locked;

whoops.
