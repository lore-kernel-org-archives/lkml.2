Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1EFS0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab1EFS0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:26:50 -0400
Date: Fri, 6 May 2011 20:26:43 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        kamezawa.hiroyu@jp.fujisu.com, minchan.kim@gmail.com,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]mm/compation.c: checking page in lru twice
Message-ID: <20110506182643.GH6330@random.random>
References: <1304681575.15473.4.camel@figo-desktop>
 <20110506130955.GF4941@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506130955.GF4941@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 02:09:55PM +0100, Mel Gorman wrote:
> On Fri, May 06, 2011 at 07:32:46PM +0800, Figo.zhang wrote:
> > 
> > in isolate_migratepages() have check page in LRU twice, the next one
> > at _isolate_lru_page(). 
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com> 
> 
> Not checking for PageLRU means that PageTransHuge() gets called
> for each page. While the scanner is active and the lock released,
> a transparent hugepage can be created and potentially we test
> PageTransHuge() on a tail page. This will trigger a BUG if
> CONFIG_DEBUG_VM is set.

Agreed. The compound_order also would become unsafe even if it was
initially an head page (if it's a compound page not in lru). And
compound_trans_order isn't a solution either because we need to be
head for it to be safe like you said, better not having to use
compound_trans_order.
