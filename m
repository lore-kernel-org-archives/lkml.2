Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0KIDSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:18:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53312 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0KIDSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:18:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 01 of 66] disable lumpy when compaction is enabled
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <ca2fea6527833aad8adc.1288798056@v2.random>
References: <patchbomb.1288798055@v2.random> <ca2fea6527833aad8adc.1288798056@v2.random>
Message-Id: <20101109121318.BC51.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 12:18:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Compaction is more reliable than lumpy, and lumpy makes the system unusable
> when it runs.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -274,6 +274,7 @@ unsigned long shrink_slab(unsigned long 
>  static void set_lumpy_reclaim_mode(int priority, struct scan_control *sc,
>  				   bool sync)
>  {
> +#ifndef CONFIG_COMPACTION
>  	enum lumpy_mode mode = sync ? LUMPY_MODE_SYNC : LUMPY_MODE_ASYNC;
>  
>  	/*
> @@ -294,11 +295,14 @@ static void set_lumpy_reclaim_mode(int p
>  		sc->lumpy_reclaim_mode = mode;
>  	else
>  		sc->lumpy_reclaim_mode = LUMPY_MODE_NONE;
> +#endif
>  }

I'm talking very personal thing now. I'm usually testing both feature.
Then, runtime switching makes my happy :-)
However I don't know what are you and Mel talking and agree about this.
So, If many developer prefer this approach, I don't oppose anymore.

But, I bet almost all distro choose CONFIG_COMPACTION=y. then, lumpy code
will become nearly dead code. So, I like just kill than dead code. however
it is also only my preference. ;)



