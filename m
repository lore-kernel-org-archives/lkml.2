Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2BNIqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:46:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47589 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2BNIqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:46:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 17:44:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/6 v4] memcg: simplify move_account() check
Message-Id: <20120214174442.3efcb22c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAHH2K0Ynh6o5fMXnkbaYOSwYYvJhc7F3f48TsJ34hki6WDJF6Q@mail.gmail.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120214120756.0a42f065.kamezawa.hiroyu@jp.fujitsu.com>
	<CAHH2K0Ynh6o5fMXnkbaYOSwYYvJhc7F3f48TsJ34hki6WDJF6Q@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 23:21:34 -0800
Greg Thelen <gthelen@google.com> wrote:

> On Mon, Feb 13, 2012 at 7:07 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From 9cdb3b63dc8d08cc2220c54c80438c13433a0d12 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Thu, 2 Feb 2012 10:02:39 +0900
> > Subject: [PATCH 2/6] memcg: simplify move_account() check.
> >
> > In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
> > a logic, flag + rcu_read_lock(), is used. This works as following
> >
> >     CPU-A                     CPU-B
> >                             rcu_read_lock()
> >    set flag
> >                             if(flag is set)
> >                                   take heavy lock
> >                             do job.
> >    synchronize_rcu()        rcu_read_unlock()
> 
> I assume that CPU-A will take heavy lock after synchronize_rcu() when
> updating variables read by CPU-B.
> 
Ah, yes. I should wrote that.

> >  memcontrol.c |   65 ++++++++++++++++++++++-------------------------------------
> >  1 file changed, 25 insertions(+), 40 deletions(-)
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Acked-by: Greg Thelen <gthelen@google.com>
> 

Thank you!.

-Kame

