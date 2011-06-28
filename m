Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1F1IRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:17:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60610 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1F1IOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:14:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jun 2011 17:06:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        nishimura@mxp.nes.nec.co.jp, yinghan@google.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] memcg: fix direct softlimit reclaim to be called
 in limit path
Message-Id: <20110628170649.87043e05.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110628080847.GA16518@tiehlicka.suse.cz>
References: <201106272318.p5RNICJW001465@imap1.linux-foundation.org>
	<20110628080847.GA16518@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011 10:08:47 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> I am sorry, that I am answering that late but I didn't get to this
> sooner.
> 
> On Mon 27-06-11 16:18:12, Andrew Morton wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > commit d149e3b ("memcg: add the soft_limit reclaim in global direct
> > reclaim") adds a softlimit hook to shrink_zones().  By this, soft limit is
> > called as
> > 
> >    try_to_free_pages()
> >        do_try_to_free_pages()
> >            shrink_zones()
> >                mem_cgroup_soft_limit_reclaim()
> > 
> > Then, direct reclaim is memcg softlimit hint aware, now.
> > 
> > But, the memory cgroup's "limit" path can call softlimit shrinker.
> > 
> >    try_to_free_mem_cgroup_pages()
> >        do_try_to_free_pages()
> >            shrink_zones()
> >                mem_cgroup_soft_limit_reclaim()
> > 
> > This will cause a global reclaim when a memcg hits limit.
> 
> Sorry, I do not get it. How does it cause the global reclaim? Did you
> mean soft reclaim?
> 

yes. soft reclaim does global reclaim (in some means). 

Thanks,
-Kame

