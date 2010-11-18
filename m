Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab0KRRN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:13:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58408 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0KRRNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:13:55 -0500
Date: Thu, 18 Nov 2010 17:13:39 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 02 of 66] mm, migration: Fix race between
	shift_arg_pages and rmap_walk by guaranteeing rmap_walk finds PTEs
	created within the temporary stack
Message-ID: <20101118171339.GM8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <ad7a334318ea379be733.1288798057@v2.random> <20101118111349.GG8135@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101118111349.GG8135@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:13:49AM +0000, Mel Gorman wrote:
> > This patch fixes the problem by using two VMAs - one which covers the temporary
> > stack and the other which covers the new location. This guarantees that rmap
> > can always find the migration PTE even if it is copied while rmap_walk is
> > taking place.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> This old chestnut. IIRC, this was the more complete solution to a fix that made
> it into mainline. The patch still looks reasonable. It does add a kmalloc()
> but I can't remember if we decided we were ok with it or not. Can you remind
> me? More importantly, it appears to be surviving the original testcase that
> this bug was about (20 minutes so far but will leave it a few hours). Assuming
> the test does not crash;
> 

Incidentally, after 6.5 hours this still hasn't crashed. Previously a
worst case reproduction scenario for the bug was around 35 minutes.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
