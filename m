Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0ICV5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:57:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932116Ab0ICV5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:57:12 -0400
Date: Fri, 3 Sep 2010 14:56:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no
 swap system
Message-Id: <20100903145646.15063c1d.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimTpj+CSvGx=HC4qnArBV9jxORkKoDA9eap3_cN@mail.gmail.com>
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
	<20100903140649.09dee316.akpm@linux-foundation.org>
	<AANLkTimTpj+CSvGx=HC4qnArBV9jxORkKoDA9eap3_cN@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 14:47:03 -0700
Ying Han <yinghan@google.com> wrote:

> > We don't have any quantitative data on the effect of these excess tlb
> > flushes, which makes it difficult to decide which kernel versions
> > should receive this patch.
> >
> > Help?
> 
> Andrew:
> 
> We observed the degradation on 2.6.34 compared to 2.6.26 kernel. The
> workload we are running is doing 4k-random-write which runs about 3-4
> minutes. We captured the TLB shootsdowns before/after:
> 
> Before the change:
> TLB: 29435 22208 37146 25332 47952 43698 43545 40297 49043 44843 46127
> 50959 47592 46233 43698 44690 TLB shootdowns [HSUM =  662798 ]
> 
> After the change:
> TLB: 2340 3113 1547 1472 2944 4194 2181 1212 2607 4373 1690 1446 2310
> 3784 1744 1134 TLB shootdowns [HSUM =  38091 ]

Do you have data on how much additional CPU time (and/or wall time) was
consumed?

> Also worthy to mention, we are running in fake numa system where each
> fake node is 128M size. That makes differences on the check
> inactive_anon_is_low() since the active/inactive ratio falls to 1.
