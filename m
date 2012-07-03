Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2GCVi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 17:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab2GCViv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 17:38:51 -0400
Message-ID: <4FF3662A.9070700@redhat.com>
Date: Tue, 03 Jul 2012 17:37:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
References: <1340315835-28571-1-git-send-email-riel@surriel.com> <1340315835-28571-2-git-send-email-riel@surriel.com> <20120629234638.GA27797@google.com>
In-Reply-To: <20120629234638.GA27797@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 07:46 PM, Michel Lespinasse wrote:

I have the free_gap(node) function now.

>>   	rb_link_node(&vma->vm_rb, rb_parent, rb_link);
>>   	rb_insert_color(&vma->vm_rb,&mm->mm_rb);
>> +	adjust_free_gap(vma);
>> +	/* Propagate the new free gap between next and us up the tree. */
>> +	if (vma->vm_next)
>> +		adjust_free_gap(vma->vm_next);
>>   }
>
> So this will work, and may be fine for a first implementation. However,
> the augmented rbtree support really seems inadequate here. What we
> would want is for adjust_free_gap to adjust the node's free_gap as
> well as its parents, and *stop* when it reaches a node that already
> has the desired free_gap instead of going all the way to the root as
> it does now. But, to do that we would also need rb_insert_color() to
> adjust free_gap as needed when doing tree rotations, and it doesn't
> have the necessary support there.
>
> Basically, I think lib/rbtree.c should provide augmented rbtree support
> in the form of (versions of) rb_insert_color() and rb_erase() being able to
> callback to adjust the augmented node information around tree rotations,
> instead of using (conservative, overkill) loops to adjust the augmented
> node information after the fact

That is what I originally worked on.

I threw out that code after people told me (at LSF/MM) in
no uncertain terms that I should use the augmented rbtree
code :)

Will CC you on the next version.

-- 
All rights reversed
