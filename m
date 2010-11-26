Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0KZDYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 22:24:00 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44078 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab0KZDX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 22:23:59 -0500
Date: Fri, 26 Nov 2010 08:53:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [BUG] memcg: fix false positive VM_BUG on non-SMP
Message-ID: <20101126032355.GG3298@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1290520130-9990-1-git-send-email-kirill@shutemov.name>
 <20101123121606.c07197e5.akpm@linux-foundation.org>
 <20101123210255.GA22484@cmpxchg.org>
 <20101123142247.e8566e3e.akpm@linux-foundation.org>
 <20101123225244.GB22484@cmpxchg.org>
 <20101124092337.b9fe888f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101124092337.b9fe888f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-11-24 09:23:37]:

> On Tue, 23 Nov 2010 23:52:44 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Tue, Nov 23, 2010 at 02:22:47PM -0800, Andrew Morton wrote:
> > > On Tue, 23 Nov 2010 22:02:55 +0100
> > > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > 
> > > > On Tue, Nov 23, 2010 at 12:16:06PM -0800, Andrew Morton wrote:
> > > > > On Tue, 23 Nov 2010 15:48:50 +0200
> > > > > "Kirill A. Shutsemov" <kirill@shutemov.name> wrote:
> > > > > 
> > > > > > ------------[ cut here ]------------
> > > > > > kernel BUG at mm/memcontrol.c:2155!
> > > > > 
> > > > > This bug has been there for a year, from which I conclude people don't
> > > > > run memcg on uniprocessor machines a lot.
> > > > > 
> > > > > Which is a bit sad, really.  Small machines need resource control too,
> > > > > perhaps more than large ones..
> > > > 
> > > > Admittedly, this patch is compile-tested on UP only, but it should be
> > > > obvious enough.
> > > > 
> > > > ---
> > > > From: Johannes Weiner <hannes@cmpxchg.org>
> > > > Subject: [patch] memcg: fix page cgroup lock assert on UP
> > > > 
> > > > Page cgroup locking primitives use the bit spinlock API functions,
> > > > which do nothing on UP.
> > > > 
> > > > Thus, checking the lock state can not be done by looking at the bit
> > > > directly, but one has to go through the bit spinlock API as well.
> > > > 
> > > > This fixes a guaranteed UP bug, where asserting the page cgroup lock
> > > > bit as a sanity check crashes the kernel.
> > > > 
> > > 
> > > hm, your patch is the same as Kirill's, except you named it
> > > page_is_cgroup_locked() rather than is_page_cgroup_locked().  I guess
> > > page_is_cgroup_locked() is a bit better.
> > 
> > I had not sorted by threads and somehow assumed this was another
> > forward from you of a bugzilla report or something.  I didn't see
> > Kirill's patch until now.  Sorry!
> > 
> > Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
>

Great catch! Thanks

 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
