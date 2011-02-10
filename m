Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1BJD6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:58:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56570 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1BJD6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iff70i9H+Rwz48AonQqmgR4JZnx6pU7KiCV5eImkIJ5+yqxi+swf89X9YO3Kl0x9eg
         LRvM7gYmDf5quW8Ss+LlWtuS3vxTVXB9vYCbVVxytgzrZ5Kcg3nUDtLlaIUtTOBJ4n7i
         /uh+B3K+OO2v3LoDrXvT1JwDWPR6AXSk+U6MU=
MIME-Version: 1.0
In-Reply-To: <20110210085823.2f99b81c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1297262537-7425-1-git-send-email-ozaki.ryota@gmail.com> <20110210085823.2f99b81c.kamezawa.hiroyu@jp.fujitsu.com>
From: Ryota Ozaki <ozaki.ryota@gmail.com>
Date: Thu, 10 Feb 2011 12:58:21 +0900
Message-ID: <AANLkTikdBhSWAoP6TDRExSV2rHmWDkEc0foSKvqJt=tx@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix out-of-date comments which refers non-existent functions
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 8:58 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed,  9 Feb 2011 23:42:17 +0900
> Ryota Ozaki <ozaki.ryota@gmail.com> wrote:
>
>> From: Ryota Ozaki <ozaki.ryota@gmail.com>
>>
>> do_file_page and do_no_page don't exist anymore, but some comments
>> still refers them. The patch fixes them by replacing them with
>> existing ones.
>>
>> Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks, Kamezawa-san.

>
> It seems there are other ones ;)
> ==
>    Searched full:do_no_page (Results 1 - 3 of 3) sorted by relevancy
>
>  /linux-2.6-git/arch/alpha/include/asm/
> H A D   cacheflush.h    66 /* This is used only in do_no_page and do_swap_page. */
>  /linux-2.6-git/arch/avr32/mm/
> H A D   cache.c         116 * This one is called from do_no_page(), do_swap_page() and install_page().
>  /linux-2.6-git/mm/
> H A D   memory.c        2121 * and do_anonymous_page and do_no_page can safely check later on).
> 2319 * do_no_page is protected similarly.

Nice catch :-) Cloud I assemble all fixes into one patch?

  ozaki-r

>
>
>
>
>
>> ---
>>  mm/memory.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> I'm not familiar with the codes very much, so the fix may be wrong.
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 31250fa..3fbf32a 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2115,10 +2115,10 @@ EXPORT_SYMBOL_GPL(apply_to_page_range);
>>   * handle_pte_fault chooses page fault handler according to an entry
>>   * which was read non-atomically.  Before making any commitment, on
>>   * those architectures or configurations (e.g. i386 with PAE) which
>> - * might give a mix of unmatched parts, do_swap_page and do_file_page
>> + * might give a mix of unmatched parts, do_swap_page and do_nonlinear_fault
>>   * must check under lock before unmapping the pte and proceeding
>>   * (but do_wp_page is only called after already making such a check;
>> - * and do_anonymous_page and do_no_page can safely check later on).
>> + * and do_anonymous_page can safely check later on).
>>   */
>>  static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
>>                               pte_t *page_table, pte_t orig_pte)
>> @@ -2316,7 +2316,7 @@ reuse:
>>                * bit after it clear all dirty ptes, but before a racing
>>                * do_wp_page installs a dirty pte.
>>                *
>> -              * do_no_page is protected similarly.
>> +              * __do_fault is protected similarly.
>>                */
>>               if (!page_mkwrite) {
>>                       wait_on_page_locked(dirty_page);
>> --
>> 1.7.2.3
>>
>>
>
>
