Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2BLRy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:54:58 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40664 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2BLRy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:54:56 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrea Righi <andrea@betterlinux.com>, Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
In-Reply-To: <20120212115834.GA1548@thinkpad>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <CAJd=RBBQFuxUC4XvS7OaajzKq1Xh0yRjY62PaceWprob26N9QA@mail.gmail.com> <20120212115834.GA1548@thinkpad>
User-Agent: Notmuch/0.11.1+167~ge466660 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 12 Feb 2012 23:24:27 +0530
Message-ID: <87sjigx7ho.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12021207-1396-0000-0000-000000A9D3BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Feb 2012 12:58:34 +0100, Andrea Righi <andrea@betterlinux.com> wrote:
> On Sun, Feb 12, 2012 at 03:16:07PM +0800, Hillf Danton wrote:
> > Hello Andrea
> > 
> > On Sun, Feb 12, 2012 at 8:21 AM, Andrea Righi <andrea@betterlinux.com> wrote:
> > [...]
> > >  - Some of the routines to implement the generic interval tree has been taken
> > >   from the x86 PAT code, that uses interval trees to keep track of PAT ranges
> > >   (in the future it would be interesting to convert also the x86 PAT code to
> > >   use the generic interval tree implementation).
> > >
> > Perhaps the tree implemented in this work could also be used in tracking
> > regions in mm/hugetlb.c.
> > 
> > Thanks
> > Hillf
> 
> Thanks, Hillf.
> 
> Yes, I quickly looked at the hugtlb code, it seems another potential
> user of the interval tree. Now all the hugetlb regions are stored in a
> list, the interval tree is a more efficient structure for lookups -
> O(log(n)), so there are probably advantages in presence of many
> different disjoint intervals.
> 
> mmh... at the moment there's not a way to map region_count() with the
> current kinterval API, but we can easily extend it to provide also this
> feature (count the overlap size of two intervals).
> 

I am also extending the hugetlb region list in the hugetlb cgroup
patchset i recently posted to make sure we don't merge region if the
associated private data doesn't match (in my case it is the pointer to
hugetlb cgroup). Ref:
http://article.gmane.org/gmane.linux.kernel.mm/73829

The goal is to make sure a region add with different private value
results in below.


    old
      |       hcg1      |
      -------------------

new
|             hcg2               |
----------------------------------

results in 

 | hcg2   | |     hcg1       | |   hcg2 |
 ---------  __________________ ----------


-aneesh

