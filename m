Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2HNML0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:11:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33887 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2HNMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <1344324343-3817-3-git-send-email-walken@google.com>
References: <1344324343-3817-1-git-send-email-walken@google.com>
	<1344324343-3817-3-git-send-email-walken@google.com>
Date: Tue, 14 Aug 2012 20:11:24 +0800
Message-ID: <CAJd=RBDnwDJzWACwW-z-1CZ-VEkpiHbCSfskapW+_+=ErWVVGw@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm: replace vma prio_tree with an interval tree
From: Hillf Danton <dhillf@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, peterz@infradead.org, vrajesh@umich.edu,
        daniel.santos@pobox.com, aarcange@redhat.com, dwmw2@infradead.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 3:25 PM, Michel Lespinasse <walken@google.com> wrote:

> +#define ITSTRUCT   struct vm_area_struct
> +#define ITSTART(n) ((n)->vm_pgoff)
> +#define ITLAST(n)  ((n)->vm_pgoff + \
> +                   (((n)->vm_end - (n)->vm_start) >> PAGE_SHIFT) - 1)

[...]

> @@ -1547,7 +1545,6 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
>         struct address_space *mapping = page->mapping;
>         pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
>         struct vm_area_struct *vma;
> -       struct prio_tree_iter iter;
>         int ret = SWAP_AGAIN;
>         unsigned long cursor;
>         unsigned long max_nl_cursor = 0;
> @@ -1555,7 +1552,7 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
>         unsigned int mapcount;
>
>         mutex_lock(&mapping->i_mmap_mutex);
> -       vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> +       vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {

Given the above defines for ITSTART and ITLAST, page index perhaps could not
be used directly in scanning interval tree for vma when ttum hugetlb page?
