Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1FZWtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610Ab1FZWrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:47:51 -0400
Message-ID: <4E07B6D6.8070203@redhat.com>
Date: Sun, 26 Jun 2011 18:46:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Righi <andrea@betterlinux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@mit.edu>, Shaohua Li <shaohua.li@intel.com>,
        =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] mm: introduce __invalidate_mapping_pages()
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com> <1308923350-7932-2-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1308923350-7932-2-git-send-email-andrea@betterlinux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 09:49 AM, Andrea Righi wrote:

> diff --git a/mm/truncate.c b/mm/truncate.c
> index 3a29a61..90f3a97 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -312,20 +312,27 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
>   EXPORT_SYMBOL(truncate_inode_pages);
>
>   /**
> - * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
> + * __invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
>    * @mapping: the address_space which holds the pages to invalidate
>    * @start: the offset 'from' which to invalidate
>    * @end: the offset 'to' which to invalidate (inclusive)
> + * @force: always drop pages when true (otherwise, reduce cache eligibility)

I don't like the parameter name "force".

The parameter determines whether or not pages actually get
invalidated, so I'm guessing the parameter name should
reflect the function...

Maybe something like "invalidate"?

-- 
All rights reversed
