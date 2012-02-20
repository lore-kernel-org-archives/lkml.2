Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2BTAdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:33:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35131 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2BTAdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:33:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Feb 2012 09:32:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] mm: memory book keeping and lru_lock
 splitting
Message-Id: <20120220093217.764e49f3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202172312030.14811@eggly.anvils>
References: <20120215224221.22050.80605.stgit@zurg>
	<alpine.LSU.2.00.1202151815180.19722@eggly.anvils>
	<4F3C8B67.6090500@openvz.org>
	<alpine.LSU.2.00.1202161235430.2269@eggly.anvils>
	<alpine.LSU.2.00.1202171803380.25191@eggly.anvils>
	<4F3F46B7.40100@openvz.org>
	<alpine.LSU.2.00.1202172312030.14811@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 23:14:01 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Sat, 18 Feb 2012, Konstantin Khlebnikov wrote:
> > Hugh Dickins wrote:
> > > On Thu, 16 Feb 2012, Hugh Dickins wrote:
> > > > 
> > > > Yours are not the only patches I was testing in that tree, I tried to
> > > > gather several other series which I should be reviewing if I ever have
> > > > time: Kamezawa-san's page cgroup diet 6, Xiao Guangrong's 4 prio_tree
> > > > cleanups, your 3 radix_tree changes, your 6 shmem changes, your 4 memcg
> > > > miscellaneous, and then your 15 books.
> > > > 
> > > > The tree before your final 15 did well under pressure, until I tried to
> > > > rmdir one of the cgroups afterwards: then it crashed nastily, I'll have
> > > > to bisect into that, probably either Kamezawa's or your memcg changes.
> > > 
> > > So far I haven't succeeded in reproducing that at all: it was real,
> > > but obviously harder to get than I assumed - indeed, no good reason
> > > to associate it with any of those patches, might even be in 3.3-rc.
> > > 
> > > It did involve a NULL pointer dereference in mem_cgroup_page_lruvec(),
> > > somewhere below compact_zone() - but repercussions were causing the
> > > stacktrace to scroll offscreen, so I didn't get good details.
> > 
> > There some stupid bugs in my v1 patchset, it shouldn't works at all.
> > I did not expect that someone will try to use it. I sent it just to discuss.
> 
> Yes, but as I said, that bug appeared before I put your patchset (the 15) on.
> 

Hm, NULL pointer dereference in mem_cgroup_page_lruvec() via comaction tend to
mean pc->mem_cgroup was NULL... 

IIUC,

- compaction get pages from LRU list and isolate/migrate them. So, When pages
  on LRU were migrated by compact_zone(), pc->mem_cgroup never be NULL..
- All newly allocated pages for migration will be reset by mem_cgroup_reset_owner().

Hm, something unexpected happens..

Regards,
-Kame
 

