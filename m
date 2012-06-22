Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942Ab2FVJuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:50:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:35423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab2FVJuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:50:06 -0400
Message-ID: <1340358580.18025.53.camel@twins>
Subject: Re: [PATCH -mm v2 04/11] rbtree: add helpers to find nearest uncle
 node
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Date: Fri, 22 Jun 2012 11:49:40 +0200
In-Reply-To: <1340315835-28571-5-git-send-email-riel@surriel.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	 <1340315835-28571-5-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 17:57 -0400, Rik van Riel wrote:
> It is useful to search an augmented rbtree based on the augmented
> data, ie. not using the sort key as the primary search criterium.
> However, we may still need to limit our search to a sub-part of the
> whole tree, using the sort key as limiters where we can search.
> 
> In that case, we may need to stop searching in one part of the tree,
> and continue the search at the nearest (great-?)uncle node in a particular
> direction.
> 
> Add helper functions to find the nearest uncle node.

I don't think we need these at all, in fact, I cannot prove your lookup
function is O(log n) at all, since the uncle might not have a suitable
max gap size, so you might need to find yet another uncle etc.


