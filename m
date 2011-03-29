Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1C2AT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:19:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39853 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1C2ATY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:19:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 09:12:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-Id: <20110329091254.20c7cfcb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
References: <20110328093957.089007035@suse.cz>
	<AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 11:01:18 -0700
Ying Han <yinghan@google.com> wrote:

> On Mon, Mar 28, 2011 at 2:39 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > Hi all,
> >
> > Memory cgroups can be currently used to throttle memory usage of a group of
> > processes. It, however, cannot be used for an isolation of processes from
> > the rest of the system because all the pages that belong to the group are
> > also placed on the global LRU lists and so they are eligible for the global
> > memory reclaim.
> >
> > This patchset aims at providing an opt-in memory cgroup isolation. This
> > means that a cgroup can be configured to be isolated from the rest of the
> > system by means of cgroup virtual filesystem (/dev/memctl/group/memory.isolated).
> 
> Thank you Hugh pointing me to the thread. We are working on similar
> problem in memcg currently
> 
> Here is the problem we see:
> 1. In memcg, a page is both on per-memcg-per-zone lru and global-lru.
> 2. Global memory reclaim will throw page away regardless of cgroup.
> 3. The zone->lru_lock is shared between per-memcg-per-zone lru and global-lru.
> 
> And we know:
> 1. We shouldn't do global reclaim since it breaks memory isolation.
> 2. There is no need for a page to be on both LRU list, especially
> after having per-memcg background reclaim.
> 
> So our approach is to take off page from global lru after it is
> charged to a memcg. Only pages allocated at root cgroup remains in
> global LRU, and each memcg reclaims pages on its isolated LRU.
> 

Why you don't use cpuset and virtual nodes ? It's what you want.

Thanks,
-Kame

