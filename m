Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0D1AcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:32:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53095 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0D1AcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:32:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 09:28:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] mm,migration: During fork(), wait for migration to
 end if migration PTE is encountered
Message-Id: <20100428092802.816e2716.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100428001911.GG510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-2-git-send-email-mel@csn.ul.ie>
	<20100427222245.GE8860@random.random>
	<20100428085203.4336b761.kamezawa.hiroyu@jp.fujitsu.com>
	<20100428001821.GF510@random.random>
	<20100428001911.GG510@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 02:19:11 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Apr 28, 2010 at 02:18:21AM +0200, Andrea Arcangeli wrote:
> > On Wed, Apr 28, 2010 at 08:52:03AM +0900, KAMEZAWA Hiroyuki wrote:
> > > I already explained this doesn't happend and said "I'm sorry".
> > 
> > Oops I must have overlooked it sorry! I just seen the trace quoted in
> > the comment of the patch and that at least would need correction
> > before it can be pushed in mainline, or it creates huge confusion to
> > see a reverse trace for CPU A for an already tricky piece of code.
> > 
> > > But considering maintainance, it's not necessary to copy migration ptes
> > > and we don't have to keep a fundamental risks of migration circus.
> > > 
> > > So, I don't say "we don't need this patch."
> > 
> > split_huge_page also has the same requirement and there is no bug to
> > fix, so I don't see why to make special changes for just migrate.c
> > when we still have to list_add_tail for split_huge_page.
> > 
> > Furthermore this patch isn't fixing anything in any case and it looks
> > a noop to me. If the order ever gets inverted, and process2 ptes are
> > scanned before process1 ptes in the rmap_walk, sure the
> > copy-page-tables will break and stop until the process1 rmap_walk will
> > complete, but that is not enough! You have to repeat the rmap_walk of
> > process1 if the order ever gets inverted and this isn't happening in
>   ^^^^^^^2

why we have to remove migration_pte by rmap_walk() which doesnt' exist ?

Anyway, I agree there are no oops. But there are risks because migration is
a feature which people don't tend to take care of (as memcg ;)
I like conservative approach for this kind of features.

Thanks,
-Kame










 

