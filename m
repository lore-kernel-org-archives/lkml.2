Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2FZNHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:07:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab2FZNHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:07:17 -0400
Message-ID: <4FE9B3B4.1050305@redhat.com>
Date: Tue, 26 Jun 2012 09:05:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org, danielfsantos@att.net
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
References: <1340315835-28571-1-git-send-email-riel@surriel.com>      <1340315835-28571-2-git-send-email-riel@surriel.com>     <1340359115.18025.57.camel@twins> <4FE47D0E.3000804@redhat.com>    <1340374439.18025.75.camel@twins> <4FE48054.5090407@redhat.com>   <1340375872.18025.77.camel@twins> <4FE4922D.8070501@surriel.com>  <1340652578.21991.18.camel@twins> <4FE8DD80.9040108@redhat.com> <1340699507.21991.32.camel@twins>
In-Reply-To: <1340699507.21991.32.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 04:31 AM, Peter Zijlstra wrote:

> If you look at your patch 1, __vma_unlink has an adjust_free_gap() right
> next to the rb_augment_erase(), vma_adjust() has 3 adjust_free_gap()
> calls right next to each other.
>
> All these will do an entire path walk back to the root. I would think we
> could save quite a bit of updating by not having them all walk back to
> the root. No point in re-computing the top levels if you know the next
> update will change them again anyway.

The problem is, unless we look at the augmented data at
rotate time, we do not know when it is safe to stop
iterating up the tree.

-- 
All rights reversed
