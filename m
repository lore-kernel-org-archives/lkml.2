Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1AUGkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:40:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1AUGkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xApzOLQTh+tV28gJX6WSbyhO5MaPILlDLRMDJ/q/pbqj3nUSbNZDgqwCdqhiLweMRD
         MdMCqE+AreXezINE1YC8KjFEREBF4p8qdZIvo1rytG1Kiqr85UlmE+pheIpaxeK++umT
         Z8xFL+uKV4k7fYEQ9ounBY1QsMPBvzvBlzj8g=
MIME-Version: 1.0
In-Reply-To: <1295591340-1862-4-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1295591340-1862-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1295591340-1862-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 21 Jan 2011 15:40:35 +0900
Message-ID: <AANLkTikOdCzhsw3_JQtbJOmA8CRm2hCZEY0LLw5uYtmM@mail.gmail.com>
Subject: Re: [PATCH 3/7] remove putback_lru_pages() in hugepage migration context
From: Minchan Kim <minchan.kim@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <tatsu@ab.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        tony.luck@intel.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 21, 2011 at 3:28 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> This putback_lru_pages() is inserted at cf608ac19c to allow
> memory compaction to count the number of migration failed pages.
>
> But we should not do it for a hugepage because page->lru of a hugepage
> is used differently from that of a normal page:
>
>   in-use hugepage : page->lru is unlinked,
>   free hugepage   : page->lru is linked to the free hugepage list,
>
> so putting back hugepages to LRU lists collapses this rule.
> We just drop this change (without any impact on memory compaction.)
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>

As I said previously, It seems mistake during patch merge.
I didn't add it in my original patch. You can see my final patch.
https://lkml.org/lkml/2010/8/24/248

Anyway, I realized it recently so I sent the patch to Andrew.
Could you see this one?
https://lkml.org/lkml/2011/1/20/241

Thanks for notice me.



-- 
Kind regards,
Minchan Kim
