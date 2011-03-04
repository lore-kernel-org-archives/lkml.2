Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab1CDIax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:30:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56109 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1CDIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:30:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Mar 2011 17:24:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Subject: Re: cgroup memory, blkio and the lovely swapping
Message-Id: <20110304172430.19a3824a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110304091132.6de2ed94@sol>
References: <20110304083944.22fb612f@sol>
	<20110304165455.d438342a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110304091132.6de2ed94@sol>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 09:11:32 +0100
Daniel Poelzleithner <poelzi@poelzi.org> wrote:

> On Fri, 4 Mar 2011 16:54:55 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Now, blkio cgroup does work only with synchronous I/O(direct I/O)
> > and never work with swap I/O. And I don't think swap-i/o limit
> > is a blkio matter.
> 
> I'm totally unsure about what subsystem it really belongs to. It is
> memory for sure, but disk access, which it actually affects, belongs to
> the blkio subsystem. Is there a technical reason why swap I/O is not run
> through the blkio system ?
> 

Now, blkio cgroup has no tags on each page. Then, it works only when
it can detect a thread which starts I/O in block layer.
But there is an activity to fix that.

http://marc.info/?l=linux-mm&m=129888823027871&w=2

I think you can discuss swap io handling in this thread.

> 
> > Memory cgroup is now developping dirty_ratio for memory cgroup.
> > By that, you can control the number of pages in writeback, in memory
> > cgroup. I think it will work for you.
> 
> I'm not sure that fixes the fairness problem on swapio. Just having a
> larger buffer before a writeback happens will reduce seeks, but not
> give fair share of io in swap in. It's good to control over it on
> cgroup level, but i doubt it will fix the problem.
> 

swap-in is out-of-control from memcg's view and have no plans.
IHMO, the number of swap-in will be blkio cgroup matter.

Thanks,
-Kame 

