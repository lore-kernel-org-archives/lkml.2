Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2FVOMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975Ab2FVOMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:12:35 -0400
Message-ID: <4FE47D0E.3000804@redhat.com>
Date: Fri, 22 Jun 2012 10:11:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
References: <1340315835-28571-1-git-send-email-riel@surriel.com>  <1340315835-28571-2-git-send-email-riel@surriel.com> <1340359115.18025.57.camel@twins>
In-Reply-To: <1340359115.18025.57.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 05:58 AM, Peter Zijlstra wrote:
> On Thu, 2012-06-21 at 17:57 -0400, Rik van Riel wrote:
>> @@ -1941,6 +2017,8 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>>          *insertion_point = vma;
>>          if (vma)
>>                  vma->vm_prev = prev;
>> +       if (vma)
>> +               rb_augment_erase_end(&vma->vm_rb, vma_rb_augment_cb, NULL);
>
> Shouldn't that be adjust_free_gap()? There is after all no actual erase
> happening.

You are right. I will fix this and also adjust the comment
above adjust_free_gap().

I am still trying to wrap my brain around your alternative
search algorithm, not sure if/how it can be combined with
arbitrary address limits and alignment...

-- 
All rights reversed
