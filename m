Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0DXCMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:12:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59698 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0DXCMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:12:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Sat, 24 Apr 2010 11:08:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: paulmck@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix v3
Message-Id: <20100424110805.17c7f86e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100423193406.GD2589@linux.vnet.ibm.com>
References: <4BD10D59.9090504@cn.fujitsu.com>
	<20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>
	<4BD118E2.7080307@cn.fujitsu.com>
	<4BD11A24.2070500@cn.fujitsu.com>
	<20100423125814.01e95bce.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423130349.f320d0be.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423193406.GD2589@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 12:34:06 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Apr 23, 2010 at 01:03:49PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Fri, 23 Apr 2010 12:58:14 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Fri, 23 Apr 2010 11:55:16 +0800
> > > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > 
> > > > Li Zefan wrote:
> > > > > KAMEZAWA Hiroyuki wrote:
> > > > >> On Fri, 23 Apr 2010 11:00:41 +0800
> > > > >> Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > > >>
> > > > >>> with CONFIG_PROVE_RCU=y, I saw this warning, it's because
> > > > >>> css_id() is not under rcu_read_lock().
> > > > >>>
> > > > >> Ok. Thank you for reporting.
> > > > >> This is ok ? 
> > > > > 
> > > > > Yes, and I did some more simple tests on memcg, no more warning
> > > > > showed up.
> > > > > 
> > > > 
> > > > oops, after trigging oom, I saw 2 more warnings:
> > > > 
> > > 
> > > Thank you for good testing.
> > v3 here...sorry too rapid posting...
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I have queued this, thank you all!
> 
> However, memcg_oom_wake_function() does not yet exist in the tree
> I am using, and is_target_pte_for_mc() has changed.  I omitted the
> hunk for memcg_oom_wake_function() and edited the hunk for
> is_target_pte_for_mc().
> 
Ok, memcg_oom_wake_function is for -mm. I'll prepare another patch for -mm.


> I have queued this for others' testing, but if you would rather carry
> this patch up the memcg path, please let me know and I will drop it.
> 
I think it's ok to be fixed by your tree. I'll look at memcg later and
fix remaining things.

Thanks,
-Kame

