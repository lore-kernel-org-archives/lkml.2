Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2AKT5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:57:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47182 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab2AKT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:57:46 -0500
MIME-Version: 1.0
In-Reply-To: <4F0D8FCE.7080202@redhat.com>
References: <20120109213156.0ff47ee5@annuminas.surriel.com>
 <20120109213357.148e7927@annuminas.surriel.com> <CAHGf_=rj=aDVGWXqdq7fh_LrCFnug_mPNuuE=YdXaWpvwyjfzg@mail.gmail.com>
 <4F0D8FCE.7080202@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 14:57:25 -0500
Message-ID: <CAHGf_=qJv99TbF2eNosbeHU5pzk2e3mDer0u2U+EsXdf2p5_Aw@mail.gmail.com>
Subject: Re: [PATCH -mm 2/2] mm: kswapd carefully invoke compaction
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, aarcange@redhat.com, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe we do need some background compaction, especially
> to help allocations from network interrupts.

I completely agree.


> If you believe the compaction is better done from some
> other thread, I guess we could do that, but truthfully, if
> kswapd spends a lot of time doing compaction, I made a
> mistake somewhere :)

I don't have much experience of compaction on real production systems.
but I have a few bad experience of background lumpy reclaim. If much
network allocation is happen when kswapd get stucked large order lumpy
reclaim, kswapd can't work for making order-0 job.it was bad. I'm only
worry about similar issue will occur.

But, ok, we can fix it when we actually observed such thing. So,
please go ahead.
