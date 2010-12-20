Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0LTCcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:32:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53831 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0LTCcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:32:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC 5/5] truncate: Remove unnecessary page release
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTimaW7X6w2e=4SvynHQHO-Kv3wXGv4_NCKDsuYRR@mail.gmail.com>
References: <20101220112227.E566.A69D9226@jp.fujitsu.com> <AANLkTimaW7X6w2e=4SvynHQHO-Kv3wXGv4_NCKDsuYRR@mail.gmail.com>
Message-Id: <20101220113239.E56C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 20 Dec 2010 11:32:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 20, 2010 at 11:21 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> This patch series changes remove_from_page_cache's page ref counting
> >> rule. page cache ref count is decreased in remove_from_page_cache.
> >> So we don't need call again in caller context.
> >>
> >> Cc: Nick Piggin <npiggin@suse.de>
> >> Cc: Al Viro <viro@zeniv.linux.org.uk>
> >> Cc: linux-mm@kvack.org
> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >> ---
> >>  mm/truncate.c |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/mm/truncate.c b/mm/truncate.c
> >> index 9ee5673..8decb93 100644
> >> --- a/mm/truncate.c
> >> +++ b/mm/truncate.c
> >> @@ -114,7 +114,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
> >>        * calls cleancache_put_page (and note page->mapping is now NULL)
> >>        */
> >>       cleancache_flush_page(mapping, page);
> >> -     page_cache_release(page);       /* pagecache ref */
> >>       return 0;
> >
> > Do we _always_ have stable page reference here? IOW, I can assume
> 
> I think so.
> Because the page is locked so caller have to hold a ref to unlock it.

Hmm...

Perhaps, I'm missing something. But I think  __memory_failure() only lock 
compaund_head page. not all. example.

> 
> > cleancache_flush_page() doesn't cause NULL deref?



