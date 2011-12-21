Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1LUECS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:02:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42565 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1LUECP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:02:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 21 Dec 2011 13:00:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] memcg: reset to root_mem_cgroup at bypassing
Message-Id: <20111221130056.2f4a39b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1112201847500.1310@eggly.anvils>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112191218350.3639@eggly.anvils>
	<CABEgKgrk4X13V2Ra_g+V5J0echpj2YZfK20zaFRKP-PhWRWiYQ@mail.gmail.com>
	<20111221091347.4f1a10d8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112201847500.1310@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011 19:25:04 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Wed, 21 Dec 2011, KAMEZAWA Hiroyuki wrote:
> > On Tue, 20 Dec 2011 09:24:47 +0900
> > Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com> wrote:
> > > 2011/12/20 Hugh Dickins <hughd@google.com>:
> > > 
> > > > I speak from experience: I did *exactly* the same at "bypass" when
> > > > I introduced our mem_cgroup_reset_page(), which corresponds to your
> > > > mem_cgroup_reset_owner(); it seemed right to me that a successful
> > > > (return 0) call to try_charge() should provide a good *ptr.
> > > >
> > > ok.
> > > 
> > > > But others (Ying and Greg) pointed out that it changes the semantics
> > > > of __mem_cgroup_try_charge() in this case, so you need to justify the
> > > > change to all those places which do something like "if (ret || !memcg)"
> > > > after calling it.  Perhaps it is a good change everywhere, but that's
> > > > not obvious, so we chose caution.
> > > >
> > > > Doesn't it lead to bypass pages being marked as charged to root, so
> > > > they don't get charged to the right owner next time they're touched?
> > > >
> > > Yes. You're right.
> > > Hm. So, it seems I should add reset_owner() to the !memcg path
> > > rather than here.
> > > 
> > Considering this again..
> > 
> > Now, we catch 'charge' event only once in lifetime of anon/file page.
> > So, it doesn't depend on that it's marked as PCG_USED or not.
> 
> That's an interesting argument, I hadn't been looking at it that way.
> It's not true of swapcache, but I guess we don't need to preserve its
> peculiarities in this case.
> 
> I've not checked the (ret || !memcg) cases yet to see if any change
> needed there.
> 
> I certainly like that the success return guarantees that memcg is set.
> 
Hmm. Ok, then....I'll update patch description to be precise.
And check I can remove !memcg case in the same patch. Then, repost v2.

Thanks,
-Kame

