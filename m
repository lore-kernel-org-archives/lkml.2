Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0IBKEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:04:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37919 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0IBKEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:04:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan,tmpfs: treat used once pages on tmpfs as used once
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTikKYFkvtAktnwzrmGPf7RNVdakWn0UbcJnc5w_a@mail.gmail.com>
References: <20100901103653.974C.A69D9226@jp.fujitsu.com> <AANLkTikKYFkvtAktnwzrmGPf7RNVdakWn0UbcJnc5w_a@mail.gmail.com>
Message-Id: <20100902185926.B64E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Sep 2010 19:04:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi KOSAKI,
> 
> On Wed, Sep 1, 2010 at 10:37 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > When a page has PG_referenced, shrink_page_list() discard it only
> > if it is no dirty. This rule works completely fine if the backend
> > filesystem is regular one. PG_dirty is good signal that it was used
> > recently because flusher thread clean pages periodically. In addition,
> > page writeback is costly rather than simple page discard.
> >
> > However, When a page is on tmpfs, this heuristic don't works because
> > flusher thread don't writeback tmpfs pages. then, tmpfs pages always
> > rotate lru twice at least and it makes unnecessary lru churn. Merely
> > tmpfs streaming io shouldn't cause large anonymous page swap-out.
> 
> It seem to make sense.
> But the why admin use tmps is to keep the contents in memory as far as
> possible than other's file system.
> But this patch has a possibility for tmpfs pages to reclaim early than
> old behavior.
> 
> I admit this routine's goal is not to protect tmpfs page from too early reclaim.
> But at least, it would have affected until now.
> If it is, we might need other demotion prevent mechanism to protect tmpfs pages.
> Is split LRU enough? (I mean we consider tmpfs pages as anonymous
> which is hard to reclaim than file backed pages).

I think so. Split-LRU provide priotize anon rather than regular file. and old behavior is
obvious strange. streaming io tolerance is one of fundamental VM requirement.
So, I think current one is only historical reason.


> 
> I don't mean to oppose this patch and I don't have a any number to
> insist on my opinion.
> Just what I want is that let's think about it more carefully and
> listen other's opinions. :)
> 
> Thanks for good suggestion.
> 
> -- 
> Kind regards,
> Minchan Kim



