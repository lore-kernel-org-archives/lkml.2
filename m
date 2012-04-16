Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2DPOxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab2DPOxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:53:17 -0400
Message-ID: <4F8C3253.9030208@redhat.com>
Date: Mon, 16 Apr 2012 10:53:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
References: <20120416141423.GD2359@suse.de>
In-Reply-To: <20120416141423.GD2359@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 10:14 AM, Mel Gorman wrote:
> This patch is horribly ugly and there has to be a better way of doing
> it. I'm looking for suggestions on what s390 can do here that is not
> painful or broken.

I'm hoping the S390 arch maintainers have an idea.

Ugly or not, we'll need something to fix the bug.

> + * When the late PTE has gone, s390 must transfer the dirty flag from the
> + * storage key to struct page. We can usually skip this if the page is anon,
> + * so about to be freed; but perhaps not if it's in swapcache - there might
> + * be another pte slot containing the swap entry, but page not yet written to
> + * swap.
>    *
> - * The caller needs to hold the pte lock.
> + * set_page_dirty() is called while the page_mapcount is still postive and
> + * under the page lock to avoid races with the mapping being invalidated.
>    */
> -void page_remove_rmap(struct page *page)
> +static void propogate_storage_key(struct page *page, bool lock_required)

Do you mean "propAgate" ?

-- 
All rights reversed
