Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0DICTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 22:19:07 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:63134 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0DICTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 22:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=smKPgMJqPrg2nL4Y8nDZdeMZ/eABsKvthTe4lgBAjlUzy/btP0n/UEAg4Yx1s/yz9f
         V7szP0A4BPGfMeVTBVw6M/3QG+n50dSmT7X+yLpBStcZSu6RuBwtFugZwMs700TC00u/
         UheX/SdmusjRHE60IRrhL2V+rqYVJfYjaT7sg=
MIME-Version: 1.0
In-Reply-To: <20100408192722.687144862@chello.nl>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.687144862@chello.nl>
Date: Fri, 9 Apr 2010 11:19:01 +0900
Message-ID: <n2p28c262361004081919qad97cc0dic538d5a23642475e@mail.gmail.com>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter.

On Fri, Apr 9, 2010 at 4:17 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> There is nothing preventing the anon_vma from being detached while we
> are spinning to acquire the lock. Most (all?) current users end up
> calling something like vma_address(page, vma) on it, which has a
> fairly good chance of weeding out wonky vmas.
>
> However suppose the anon_vma got freed and re-used while we were
> waiting to acquire the lock, and the new anon_vma fits with the
> page->index (because that is the only thing vma_address() uses to
> determine if the page fits in a particular vma, we could end up
> traversing faulty anon_vma chains.

We have second defense rule by page_check_address.
Before anon_vma is detached, pte of pages on the anon_vma should be zeroed.
So can't page_check_address close the race?

Thanks for good trial for good feature.

-- 
Kind regards,
Minchan Kim
