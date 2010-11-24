Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0KXA3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:29:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49226 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab0KXA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:29:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Nov 2010 09:23:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [BUG] memcg: fix false positive VM_BUG on non-SMP
Message-Id: <20101124092337.b9fe888f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101123225244.GB22484@cmpxchg.org>
References: <1290520130-9990-1-git-send-email-kirill@shutemov.name>
	<20101123121606.c07197e5.akpm@linux-foundation.org>
	<20101123210255.GA22484@cmpxchg.org>
	<20101123142247.e8566e3e.akpm@linux-foundation.org>
	<20101123225244.GB22484@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 23:52:44 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, Nov 23, 2010 at 02:22:47PM -0800, Andrew Morton wrote:
> > On Tue, 23 Nov 2010 22:02:55 +0100
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > On Tue, Nov 23, 2010 at 12:16:06PM -0800, Andrew Morton wrote:
> > > > On Tue, 23 Nov 2010 15:48:50 +0200
> > > > "Kirill A. Shutsemov" <kirill@shutemov.name> wrote:
> > > > 
> > > > > ------------[ cut here ]------------
> > > > > kernel BUG at mm/memcontrol.c:2155!
> > > > 
> > > > This bug has been there for a year, from which I conclude people don't
> > > > run memcg on uniprocessor machines a lot.
> > > > 
> > > > Which is a bit sad, really.  Small machines need resource control too,
> > > > perhaps more than large ones..
> > > 
> > > Admittedly, this patch is compile-tested on UP only, but it should be
> > > obvious enough.
> > > 
> > > ---
> > > From: Johannes Weiner <hannes@cmpxchg.org>
> > > Subject: [patch] memcg: fix page cgroup lock assert on UP
> > > 
> > > Page cgroup locking primitives use the bit spinlock API functions,
> > > which do nothing on UP.
> > > 
> > > Thus, checking the lock state can not be done by looking at the bit
> > > directly, but one has to go through the bit spinlock API as well.
> > > 
> > > This fixes a guaranteed UP bug, where asserting the page cgroup lock
> > > bit as a sanity check crashes the kernel.
> > > 
> > 
> > hm, your patch is the same as Kirill's, except you named it
> > page_is_cgroup_locked() rather than is_page_cgroup_locked().  I guess
> > page_is_cgroup_locked() is a bit better.
> 
> I had not sorted by threads and somehow assumed this was another
> forward from you of a bugzilla report or something.  I didn't see
> Kirill's patch until now.  Sorry!
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>

Thank you.

