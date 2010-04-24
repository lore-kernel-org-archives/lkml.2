Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0DXObd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 10:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab0DXObb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 10:31:31 -0400
Date: Sat, 24 Apr 2010 16:30:44 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
 PageSwapCache  pages
Message-ID: <20100424143044.GD32034@random.random>
References: <1271946226.2100.211.camel@barrios-desktop>
 <1271947206.2100.216.camel@barrios-desktop>
 <20100422154443.GD30306@csn.ul.ie>
 <20100423183135.GT32034@random.random>
 <20100423192311.GC14351@csn.ul.ie>
 <20100423193948.GU32034@random.random>
 <20100423213549.GV32034@random.random>
 <20100424105226.GF14351@csn.ul.ie>
 <20100424111340.GB32034@random.random>
 <20100424115936.GG14351@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424115936.GG14351@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 12:59:37PM +0100, Mel Gorman wrote:
> Well, to me this is also good because it shows it's not an existing bug in
> migration or a new bug introduced by compaction either. Previously I hadn't
> seen this bug either but until relatively recently, the bulk of the testing
> was against 2.6.33.

I suggest to test again with aa.git as soon as I make a new release
with your v8 code (probably today). I didn't merge the swapcache
locked debug patch that tries to recover the thing after the fact. No
problem here with swapcache apparently and your v8 and latest numa-aware
khugepaged code is under stress for the last 12 hours.

Other than full numa awareness in all hugepage allocations and your v8
code, I added a generic document that needs review and I plan to add a
config tweak to select the default to be madvise or always for
transparent hugepage (never makes no sense, other than for debugging
purposes, madvise already provides the guarantee of zero risk of
unintentional and not guaranteed beneficial memory waste).

> Will keep it in mind. It's taking the anon_vma lock but once again,
> there might be more than one anon_vma to worry about and the proper
> locking still isn't massively clear to me.

Yes, that's my point, same issue there.
