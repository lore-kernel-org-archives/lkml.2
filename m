Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1FTEJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:09:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1FTEJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:09:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Jun 2011 13:02:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Andrew Bresticker <abrestic@google.com>
Subject: Re: [PATCH 3/7] memcg: add memory.scan_stat
Message-Id: <20110620130227.6202e8f6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110620084123.c63d3e12.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125314.4f78b1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTimYEr9k3Sk5JoaRrrQH4mGoTmL1Wf5gadYVGDuNpxofHw@mail.gmail.com>
	<20110620084123.c63d3e12.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011 08:41:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 17 Jun 2011 15:04:18 -0700
> Ying Han <yinghan@google.com> wrote:
> 
> > On Wed, Jun 15, 2011 at 8:53 PM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > From e08990dd9ada13cf236bec1ef44b207436434b8e Mon Sep 17 00:00:00 2001
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Date: Wed, 15 Jun 2011 14:11:01 +0900
> > > Subject: [PATCH 3/7] memcg: add memory.scan_stat
> > >
> > > commit log of commit 0ae5e89 " memcg: count the soft_limit reclaim in..."
> > > says it adds scanning stats to memory.stat file. But it doesn't because
> > > we considered we needed to make a concensus for such new APIs.
> > >
> > > This patch is a trial to add memory.scan_stat. This shows
> > >  - the number of scanned pages
> > >  - the number of recleimed pages
> > >  - the number of elaplsed time (including sleep/pause time)
> > >  for both of direct/soft reclaim and shrinking caused by changing limit
> > >  or force_empty.
> > >
> > > The biggest difference with oringinal Ying's one is that this file
> > > can be reset by some write, as
> > >
> > >  # echo 0 ...../memory.scan_stat
> > >
> > > [kamezawa@bluextal ~]$ cat /cgroup/memory/A/memory.scan_stat
> > > scanned_pages_by_limit 358470
> > > freed_pages_by_limit 180795
> > > elapsed_ns_by_limit 21629927
> > > scanned_pages_by_system 0
> > > freed_pages_by_system 0
> > > elapsed_ns_by_system 0
> > > scanned_pages_by_shrink 76646
> > > freed_pages_by_shrink 38355
> > > elappsed_ns_by_shrink 31990670
> > > total_scanned_pages_by_limit 358470
> > > total_freed_pages_by_limit 180795
> > > total_elapsed_ns_by_hierarchical 216299275
> > > total_scanned_pages_by_system 0
> > > total_freed_pages_by_system 0
> > > total_elapsed_ns_by_system 0
> > > total_scanned_pages_by_shrink 76646
> > > total_freed_pages_by_shrink 38355
> > > total_elapsed_ns_by_shrink 31990670
> > >
> > > total_xxxx is for hierarchy management.
> > >
> > > This will be useful for further memcg developments and need to be
> > > developped before we do some complicated rework on LRU/softlimit
> > > management.
> > 
> > Agreed. Actually we are also looking into adding a per-memcg API for
> > adding visibility of
> > page reclaim path. It would be helpful for us to settle w/ the API first.
> > 
> > I am not a fan of names, but how about
> > "/dev/cgroup/memory/memory.reclaim_stat" ?
> > 
> 
> Hm, ok, I have no favorite. 
> 
> 

If I rename, I'll just rename file name as "reclaim_stat" but doesn't
rename internal structures because there is already "struct reclaim_stat".

Hm, to be honest, I don't like the name "reclaim_stat".
(Because in most case, the pages are not freed for reclaim, but for
 hitting limit.)

memory.vmscan_info ?

Thanks,
-Kame

