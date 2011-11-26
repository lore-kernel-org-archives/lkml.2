Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1KZSx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 13:53:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1KZSx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 13:53:27 -0500
Date: Sat, 26 Nov 2011 18:33:15 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: migration: pair unlock_page and lock_page when
 migrating huge pages
Message-ID: <20111126173315.GG8397@redhat.com>
References: <CAJd=RBChfVC4hUKvO5ks0+NxahTgibdivLotw3VpAa7_-r8_+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBChfVC4hUKvO5ks0+NxahTgibdivLotw3VpAa7_-r8_+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

On Fri, Nov 25, 2011 at 08:20:31PM +0800, Hillf Danton wrote:
> Skip unlocking page if fail to lock, then lock and unlock are paired.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/migrate.c	Fri Nov 25 20:11:14 2011
> +++ b/mm/migrate.c	Fri Nov 25 20:21:26 2011
> @@ -869,9 +869,9 @@ static int unmap_and_move_huge_page(new_
> 
>  	if (anon_vma)
>  		put_anon_vma(anon_vma);
> -out:
>  	unlock_page(hpage);
> 
> +out:
>  	if (rc != -EAGAIN) {
>  		list_del(&hpage->lru);
>  		put_page(hpage);

Looks good, I guess that path wasn't exercised frequently because
there's no blocking I/O involvement with hugetlbfs.

Thanks,
Andrea
