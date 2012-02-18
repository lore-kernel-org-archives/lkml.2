Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2BRCOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 21:14:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65516 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab2BRCOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 21:14:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.236.168 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 17 Feb 2012 18:13:37 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Hugh Dickins <hughd@google.com>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] mm: memory book keeping and lru_lock
 splitting
In-Reply-To: <alpine.LSU.2.00.1202161235430.2269@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1202171803380.25191@eggly.anvils>
References: <20120215224221.22050.80605.stgit@zurg> <alpine.LSU.2.00.1202151815180.19722@eggly.anvils> <4F3C8B67.6090500@openvz.org> <alpine.LSU.2.00.1202161235430.2269@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Hugh Dickins wrote:
> 
> Yours are not the only patches I was testing in that tree, I tried to
> gather several other series which I should be reviewing if I ever have
> time: Kamezawa-san's page cgroup diet 6, Xiao Guangrong's 4 prio_tree
> cleanups, your 3 radix_tree changes, your 6 shmem changes, your 4 memcg
> miscellaneous, and then your 15 books.
> 
> The tree before your final 15 did well under pressure, until I tried to
> rmdir one of the cgroups afterwards: then it crashed nastily, I'll have
> to bisect into that, probably either Kamezawa's or your memcg changes.

So far I haven't succeeded in reproducing that at all: it was real,
but obviously harder to get than I assumed - indeed, no good reason
to associate it with any of those patches, might even be in 3.3-rc.

It did involve a NULL pointer dereference in mem_cgroup_page_lruvec(),
somewhere below compact_zone() - but repercussions were causing the
stacktrace to scroll offscreen, so I didn't get good details.

Hugh
