Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2CEUam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:30:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab2CEUal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:30:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.102.129 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120305064029.GK23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk> <20120305064029.GK23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Mar 2012 12:30:19 -0800
X-Google-Sender-Auth: rwW0aUjGGne2jx0q1pcte10-qXE
Message-ID: <CA+55aFwQtEPGwK-W8H3Fa0EZUOV057kj_xhUXONZRcyeZtSt3Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] flush_tlb_range() needs ->page_table_lock when
 ->mmap_sem is not held
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this safe? And why does it need it? Please add more explanations.

                  Linus

On Sun, Mar 4, 2012 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  mm/hugetlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 5f34bd8..a876871 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2277,8 +2277,8 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>                        set_page_dirty(page);
>                list_add(&page->lru, &page_list);
>        }
> -       spin_unlock(&mm->page_table_lock);
>        flush_tlb_range(vma, start, end);
> +       spin_unlock(&mm->page_table_lock);
>        mmu_notifier_invalidate_range_end(mm, start, end);
>        list_for_each_entry_safe(page, tmp, &page_list, lru) {
>                page_remove_rmap(page);
> --
> 1.7.2.5
>
