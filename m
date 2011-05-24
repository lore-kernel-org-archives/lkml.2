Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab1EXBkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:40:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32783 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab1EXBkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:40:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB0C89.9020803@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:40:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, dave@linux.vnet.ibm.com, hannes@cmpxchg.org,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie,
        minchan.kim@gmail.com, riel@redhat.com, xemul@openvz.org,
        yinghan@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: + vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
 added to -mm tree
References: <201105201859.p4KIxGrK024683@imap1.linux-foundation.org>
In-Reply-To: <201105201859.p4KIxGrK024683@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/21 3:59), akpm@linux-foundation.org wrote:
> The patch titled
>       vmscan: fix up new shrinker API
> has been added to the -mm tree.  Its filename is
>       vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: vmscan: fix up new shrinker API
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> 
> Current new shrinker API submission has some easy mistake. Fix it up.
> 
> - remove nr_scanned field from shrink_control.
>     we don't have to expose vmscan internal to shrinkers.
> - rename nr_slab_to_reclaim to nr_to_scan.
>     to_reclaim is very wrong name. shrinker API allow shrinker
>     don't reclaim an slab object if they were recently accessed.
> - typo: least-recently-us
> 
> This patch also make do_shrinker_shrink() helper function. It
> increase code readability a bit.

Oops. I'm sorry. This patch forgot one correction. please apply
following incremental patch.




---
 net/sunrpc/auth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 287dd25..cd6e4aa 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -330,7 +330,7 @@ rpcauth_cache_shrinker(struct shrinker *shrink, struct shrink_control *sc)
 {
 	LIST_HEAD(free);
 	int res;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;

 	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
-- 
1.7.3.1



