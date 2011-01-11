Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1AKUgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1AKUgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:36:18 -0500
Message-ID: <4D2CBF00.1080706@redhat.com>
Date: Tue, 11 Jan 2011 15:35:12 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix migration hangs on anon_vma lock
References: <alpine.LSU.2.00.1101102259160.24988@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1101102259160.24988@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 02:08 AM, Hugh Dickins wrote:
> Increased usage of page migration in mmotm reveals that the anon_vma
> locking in unmap_and_move() has been deficient since 2.6.36 (or even
> earlier).  Review at the time of f18194275c39835cb84563500995e0d503a32d9a
> "mm: fix hang on anon_vma->root->lock" missed the issue here: the anon_vma
> to which we get a reference may already have been freed back to its slab
> (it is in use when we check page_mapped, but that can change), and so its
> anon_vma->root may be switched at any moment by reuse in anon_vma_prepare.
>
> Perhaps we could fix that with a get_anon_vma_unless_zero(), but let's not:
> just rely on page_lock_anon_vma() to do all the hard thinking for us, then
> we don't need any rcu read locking over here.
>
> In removing the rcu_unlock label: since PageAnon is a bit in page->mapping,
> it's impossible for a !page->mapping page to be anon; but insert VM_BUG_ON
> in case the implementation ever changes.
>
> Signed-off-by: Hugh Dickins<hughd@google.com>
> Cc: stable@kernel.org [2.6.37, 2.6.36]

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
