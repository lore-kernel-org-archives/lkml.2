Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2AKHZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:25:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54495 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2AKHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120109213357.148e7927@annuminas.surriel.com>
References: <20120109213156.0ff47ee5@annuminas.surriel.com> <20120109213357.148e7927@annuminas.surriel.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 02:25:26 -0500
Message-ID: <CAHGf_=rj=aDVGWXqdq7fh_LrCFnug_mPNuuE=YdXaWpvwyjfzg@mail.gmail.com>
Subject: Re: [PATCH -mm 2/2] mm: kswapd carefully invoke compaction
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, aarcange@redhat.com, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With CONFIG_COMPACTION enabled, kswapd does not try to free
> contiguous free pages, even when it is woken for a higher order
> request.
>
> This could be bad for eg. jumbo frame network allocations, which
> are done from interrupt context and cannot compact memory themselves.
> Higher than before allocation failure rates in the network receive
> path have been observed in kernels with compaction enabled.
>
> Teach kswapd to defragment the memory zones in a node, but only
> if required and compaction is not deferred in a zone.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

I agree with we need asynchronous defragmentations feature. But, do we
really need to use kswapd for compaction? While kswapd take a
compaction work, it can't work to make
free memory.
