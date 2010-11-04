Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab0KDQc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab0KDQc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:32:26 -0400
Date: Thu, 4 Nov 2010 17:30:26 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: CAI Qian <caiqian@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
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
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00 of 66] Transparent Hugepage Support #32
Message-ID: <20101104163026.GH11602@random.random>
References: <690735095.1385111288840247360.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <2080208615.1392881288860072684.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2080208615.1392881288860072684.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Qian,

On Thu, Nov 04, 2010 at 04:41:12AM -0400, CAI Qian wrote:
> Thank Andrea for pointing out to me there are ongoing works for KSM
> and THP integration. Sorry for the noise.

No problem, thanks for your feedback!

The longer answer is: PageKsm pages will already co-exist fine with
PageTransHuge pages in the same vma with regular pages. So 3 type of
pages in the same vma. But before KSM scan can see the content of the
hugepages there has to be some memory pressure... So it's not ideal
and we will make KSM able to scan inside hugepages before they're
splitted (and to split them when it finds a match and then merge them
in the stable tree).

So it's perfectly normal that KSM becomes less effective when THP is
enabled. But in the mainline version we have MADV_HUGEPAGE, so if you
need KSM in full effect, you can simply "echo madvise
>/sys/kernel/mm/transparent_hugepage/enabled", and then you can decide
if to mark a mapping either with madvise(MADV_HUGEPAGE) or
madvise(MADV_MERGEABLE).

Thanks,
Andrea
