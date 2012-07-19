Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab2GSMzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:55:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64402 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2GSMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:55:52 -0400
Date: Thu, 19 Jul 2012 05:55:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Michal Hocko <mhocko@suse.cz>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>, Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCH v2] mm/memcg: use exist interface to get css from memcg
In-Reply-To: <5007E00B.6000802@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1207190552440.4949@eggly.anvils>
References: <1342609734-22437-1-git-send-email-liwanp@linux.vnet.ibm.com> <20120719092928.GA2864@tiehlicka.suse.cz> <5007E00B.6000802@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2012, Kamezawa Hiroyuki wrote:
> (2012/07/19 18:29), Michal Hocko wrote:
> > On Wed 18-07-12 19:08:54, Wanpeng Li wrote:
> > > use exist interface mem_cgroup_css instead of &mem->css.
> > 
> > This interface has been added to enable mem->css outside of
> > mm/memcontrol.c (where we define struct mem_cgroup). There is one user
> > left (hwpoison_filter_task) after recent clean ups.
> > 
> > I think we shouldn't spread the usage inside the mm/memcontrol.c. The
> > compiler inlines the function for all callers added by this patch but I
> > wouldn't rely on it. It is also unfortunate that we cannot convert all
> > dereferences (e.g. const mem_cgroup).
> > Moreover it doesn't add any additional type safety. So I would vote for
> > not taking the patch but if others like it I will not block it.
> > 
> 
> Agreed.

Very strongly agreed: I found it hard to be as polite as you have been.

Hugh
