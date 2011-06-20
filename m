Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1FTS0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1FTS0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:26:06 -0400
Date: Mon, 20 Jun 2011 14:25:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Cong Wang <amwang@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by
 transparent_hugepage=never
Message-ID: <20110620182558.GF4749@redhat.com>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <20110620165844.GA9396@suse.de>
 <4DFF7E3B.1040404@redhat.com>
 <4DFF7F0A.8090604@redhat.com>
 <4DFF8106.8090702@redhat.com>
 <4DFF8327.1090203@redhat.com>
 <4DFF84BB.3050209@redhat.com>
 <4DFF8848.2060802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF8848.2060802@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 01:50:00PM -0400, Rik van Riel wrote:
> On 06/20/2011 01:34 PM, Cong Wang wrote:
> 
> >Even if it is really 10K, why not save it since it doesn't
> >much effort to make this. ;) Not only memory, but also time,
> >this could also save a little time to initialize the kernel.
> >
> >For me, the more serious thing is the logic, there is
> >no way to totally disable it as long as I have THP in .config
> >currently. This is why I said the design is broken.
> 
> There are many things you cannot totally disable as long
> as they are enabled in the .config.  Think about things
> like swap, or tmpfs - neither of which you are going to
> use in the crashdump kernel.
> 
> I believe we need to keep the kernel optimized for common
> use and convenience.
> 
> Crashdump is very much a corner case.  Yes, using less
> memory in crashdump is worthwhile, but lets face it -
> the big memory user there is likely to be the struct page
> array, with everything else down in the noise...

We are creating struct page array only for memory visible in 
second kernel. So in this case struct page array for 128G.

One of big user is per cpu data on large cpu systems. (256 etc).
Even though we boot second kernel with maxcpus=1, it does not
change possible cpu maps and initalizes LAPIC etc and that seem
to be consuming significant amount of memory. (In the order of MBs).
So I see some opprotunity there to save memory. But this 10kB
definitely sounds trivial amount to me.

thanks
Vivek
