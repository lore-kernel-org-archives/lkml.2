Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2BSXyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:54:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56139 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BSXyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:54:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Feb 2012 08:52:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 5/6] memcg: remove PCG_FILE_MAPPED
Message-Id: <20120220085238.606dc435.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBD=U1Uy_MnO9wL_Ag6M7tYUOfs=aSXV+sJabHWRNSSudQ@mail.gmail.com>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
	<20120217182818.f3e7fe28.kamezawa.hiroyu@jp.fujitsu.com>
	<20120218133904.GA1678@cmpxchg.org>
	<CAJd=RBD=U1Uy_MnO9wL_Ag6M7tYUOfs=aSXV+sJabHWRNSSudQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Feb 2012 22:43:58 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Sat, Feb 18, 2012 at 9:39 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Fri, Feb 17, 2012 at 06:28:18PM +0900, KAMEZAWA Hiroyuki wrote:
> >> @@ -2559,7 +2555,7 @@ static int mem_cgroup_move_account(struct page *page,
> >>
> >>       move_lock_mem_cgroup(from, &flags);
> >>
> >> -     if (PageCgroupFileMapped(pc)) {
> >> +     if (page_mapped(page)) {
> >
> > As opposed to update_page_stat(), this runs against all types of
> > pages, so I think it should be
> >
> >        if (!PageAnon(page) && page_mapped(page))
> >
> > instead.
> >
> Perhaps the following helper or similar needed,
> along with page_mapped()
> 
> static inline bool page_is_file_mapping(struct page *page)
> {
> 	struct address_space *mapping = page_mapping(page);
> 
> 	return mapping && mapping != &swapper_space &&
> 		((unsigned long)mapping & PAGE_MAPPING_FLAGS) == 0;
> }
> 

Ah, thank you. I'll post a fix soon.

Ragard,
-Kame

