Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0D1SEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0D1SEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:04:09 -0400
Date: Wed, 28 Apr 2010 20:03:36 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] take all anon_vma locks in anon_vma_lock
Message-ID: <20100428180336.GC510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-3-git-send-email-mel@csn.ul.ie>
 <20100427231007.GA510@random.random>
 <20100428091555.GB15815@csn.ul.ie>
 <20100428153525.GR510@random.random>
 <20100428155558.GI15815@csn.ul.ie>
 <20100428162305.GX510@random.random>
 <20100428134719.32e8011b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428134719.32e8011b@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 01:47:19PM -0400, Rik van Riel wrote:
>  static inline void anon_vma_unlock(struct vm_area_struct *vma)

never mind as this is RFC, lock is clear enough

> @@ -1762,7 +1760,8 @@ static int expand_downwards(struct vm_area_struct *vma,
>  	if (error)
>  		return error;
>  
> -	anon_vma_lock(vma);
> +	spin_lock(&mm->page_table_lock);
> +	anon_vma_lock(vma, &mm->page_table_lock);

This will cause a lock inversion (page_table_lock can only be taken
after the anon_vma lock). I don't immediately see why the
page_table_lock here though?
