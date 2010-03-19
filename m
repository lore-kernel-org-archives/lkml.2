Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0CSDEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:04:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41585 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CSDEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:04:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Mar 2010 12:00:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrea Righi <arighi@develer.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
Message-Id: <20100319120049.3dbf8440.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100319024039.GH18054@balbir.in.ibm.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
	<1268609202-15581-2-git-send-email-arighi@develer.com>
	<20100317115855.GS18054@balbir.in.ibm.com>
	<20100318085411.834e1e46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318041944.GA18054@balbir.in.ibm.com>
	<20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318162855.GG18054@balbir.in.ibm.com>
	<20100319102332.f1d81c8d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100319024039.GH18054@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 08:10:39 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-19 10:23:32]:
> 
> > On Thu, 18 Mar 2010 21:58:55 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-18 13:35:27]:
> > 
> > > > Then, no probelm. It's ok to add mem_cgroup_udpate_stat() indpendent from
> > > > mem_cgroup_update_file_mapped(). The look may be messy but it's not your
> > > > fault. But please write "why add new function" to patch description.
> > > > 
> > > > I'm sorry for wasting your time.
> > > 
> > > Do we need to go down this route? We could check the stat and do the
> > > correct thing. In case of FILE_MAPPED, always grab page_cgroup_lock
> > > and for others potentially look at trylock. It is OK for different
> > > stats to be protected via different locks.
> > > 
> > 
> > I _don't_ want to see a mixture of spinlock and trylock in a function.
> >
> 
> A well documented well written function can help. The other thing is to
> of-course solve this correctly by introducing different locking around
> the statistics. Are you suggesting the later?
> 

No. As I wrote.
	- don't modify codes around FILE_MAPPED in this series.
	- add a new functions for new statistics
Then,
	- think about clean up later, after we confirm all things work as expected.

Thanks,
-Kame


