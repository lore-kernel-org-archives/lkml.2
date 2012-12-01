Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2LAUfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 15:35:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab2LAUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 15:35:06 -0500
Message-ID: <50BA69B7.30002@redhat.com>
Date: Sat, 01 Dec 2012 15:33:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] mm/migration: Make rmap_walk_anon() and try_to_unmap_anon()
 more scalable
References: <1354305521-11583-1-git-send-email-mingo@kernel.org> <CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com> <20121201094927.GA12366@gmail.com> <20121201122649.GA20322@gmail.com> <CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com> <20121201184135.GA32449@gmail.com> <CA+55aFyq7OaUxcEHXvJhp0T57KN14o-RGxqPmA+ks8ge6zJh5w@mail.gmail.com> <20121201201538.GB2704@gmail.com>
In-Reply-To: <20121201201538.GB2704@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 03:15 PM, Ingo Molnar wrote:

> Index: linux/include/linux/rmap.h
> ===================================================================
> --- linux.orig/include/linux/rmap.h
> +++ linux/include/linux/rmap.h
> @@ -128,6 +128,17 @@ static inline void anon_vma_unlock(struc
>   	up_write(&anon_vma->root->rwsem);
>   }
>
> +static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
> +{
> +	down_read(&anon_vma->root->rwsem);
> +}

I see you did not rename anon_vma_lock and anon_vma_unlock
to anon_vma_lock_write and anon_vma_unlock_write.

That could get confusing to people touching that code in
the future.

The patch looks correct, though.

-- 
All rights reversed
