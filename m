Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0CREjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 00:39:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38508 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0CREjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 00:39:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Mar 2010 13:35:27 +0900
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
Message-Id: <20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100318041944.GA18054@balbir.in.ibm.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
	<1268609202-15581-2-git-send-email-arighi@develer.com>
	<20100317115855.GS18054@balbir.in.ibm.com>
	<20100318085411.834e1e46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318041944.GA18054@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 09:49:44 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-18 08:54:11]:
> 
> > On Wed, 17 Mar 2010 17:28:55 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * Andrea Righi <arighi@develer.com> [2010-03-15 00:26:38]:
> > > 
> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > 
> > > > Now, file-mapped is maintaiend. But more generic update function
> > > > will be needed for dirty page accounting.
> > > > 
> > > > For accountig page status, we have to guarantee lock_page_cgroup()
> > > > will be never called under tree_lock held.
> > > > To guarantee that, we use trylock at updating status.
> > > > By this, we do fuzzy accounting, but in almost all case, it's correct.
> > > >
> > > 
> > > I don't like this at all, but in almost all cases is not acceptable
> > > for statistics, since decisions will be made on them and having them
> > > incorrect is really bad. Could we do a form of deferred statistics and
> > > fix this.
> > > 
> > 
> > plz show your implementation which has no performance regresssion.
> > For me, I don't neee file_mapped accounting, at all. If we can remove that,
> > we can add simple migration lock.
> 
> That doesn't matter, if you need it, I think the larger user base
> matters. Unmapped and mapped page cache is critical and I use it
> almost daily.
> 
> > file_mapped is a feattue you added. please improve it.
> >
> 
> I will, but please don't break it silently
> 
Andrea, could you go in following way ?

	- don't touch FILE_MAPPED stuff.
	- add new functions for other dirty accounting stuff as in this series.
	  (using trylock is ok.)
	
Then, no probelm. It's ok to add mem_cgroup_udpate_stat() indpendent from
mem_cgroup_update_file_mapped(). The look may be messy but it's not your
fault. But please write "why add new function" to patch description.

I'm sorry for wasting your time.

Thanks,
-Kame




