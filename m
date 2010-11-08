Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0KHJvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:51:16 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54367 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0KHJvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:51:15 -0500
Date: Mon, 8 Nov 2010 10:50:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [BUGFIX][PATCH] fix wrong VM_BUG_ON() in try_charge()'s
 mm->owner check
Message-ID: <20101108095040.GK23393@cmpxchg.org>
References: <AANLkTikCUdpx-jGhKdzueML39CnExumk1i_X_OZJihE2@mail.gmail.com>
 <alpine.LSU.2.00.1011041016520.19411@tigran.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1011041016520.19411@tigran.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 10:31:58AM -0700, Hugh Dickins wrote:
> On Wed, 3 Nov 2010, Hiroyuki Kamezawa wrote:
> > I'm sorry for attached file, I have to use unusual mailer this time.
> > This is a fix for wrong VM_BUG_ON() for mm/memcontol.c
> 
> Thanks, Kame, that's good: I've inlined it below with Balbir's Review,
> my Ack, and a Cc: stable@kernel.org.
> 
> Hugh
> 
> 
> [PATCH] memcg: fix wrong VM_BUG_ON() in try_charge()'s mm->owner check
> 
> At __mem_cgroup_try_charge(), VM_BUG_ON(!mm->owner) is checked.
> But as commented in mem_cgroup_from_task(), mm->owner can be NULL in some racy
> case. This check of VM_BUG_ON() is bad.
> 
> A possible story to hit this is at swapoff()->try_to_unuse(). It passes
> mm_struct to mem_cgroup_try_charge_swapin() while mm->owner is NULL. If we
> can't get proper mem_cgroup from swap_cgroup information, mm->owner is used
> as charge target and we see NULL.
> 
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: stable@kernel.org

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
