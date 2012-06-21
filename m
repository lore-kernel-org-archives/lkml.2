Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab2FUTGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:06:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759663Ab2FUTGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:06:51 -0400
Message-ID: <4FE350D1.4070503@redhat.com>
Date: Thu, 21 Jun 2012 12:50:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 2/7] mm: get unmapped area from VMA tree
References: <1340057126-31143-1-git-send-email-riel@redhat.com> <1340057126-31143-3-git-send-email-riel@redhat.com> <20120621090157.GG27816@cmpxchg.org>
In-Reply-To: <20120621090157.GG27816@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 05:01 AM, Johannes Weiner wrote:

>> +		/* Go left if it looks promising. */
>> +		if (node_free_hole(rb_node->rb_left)>= len&&
>> +					vma->vm_start - len>= lower_limit) {
>> +			rb_node = rb_node->rb_left;
>> +			continue;
>
> If we already are at a vma whose start has a lower address than the
> overall length, does it make sense to check for a left hole?
> I.e. shouldn't this be inside the if (vma->vm_start>  len) block?

You are right, I can move this in under the
conditional.

>> +		if (!found_here&&  node_free_hole(rb_node->rb_left)>= len) {
>> +			/* Last known hole is to the right of this subtree. */
>
> "to the left"

Actually, it is to the right.  We walked left from
our parent to get here, so the holes found so far
are to the right of here.

