Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0EGOzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:55:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57806 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab0EGOzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:55:23 -0400
Date: Fri, 7 May 2010 07:55:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] blk-cgroup: Fix an RCU warning in blkiocg_create()
Message-ID: <20100507145515.GA2368@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BD016F4.8060108@cn.fujitsu.com>
 <4BD017AC.1020209@cn.fujitsu.com>
 <20100422195725.GM2524@linux.vnet.ibm.com>
 <4BE3B985.1000407@cn.fujitsu.com>
 <20100507065741.GW27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507065741.GW27497@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 08:57:41AM +0200, Jens Axboe wrote:
> On Fri, May 07 2010, Li Zefan wrote:
> > Paul E. McKenney wrote:
> > > On Thu, Apr 22, 2010 at 05:32:28PM +0800, Li Zefan wrote:
> > >> with CONFIG_PROVE_RCU=y, a warning can be triggered:
> > >>
> > >>   # mount -t cgroup -o blkio xxx /mnt
> > >>   # mkdir /mnt/subgroup
> > >>
> > >> ...
> > >> kernel/cgroup.c:4442 invoked rcu_dereference_check() without protection!
> > >> ...
> > >>
> > >> To fix this, we avoid caling css_depth() here, which is a bit simpler
> > >> than the original code.
> > > 
> > > Queued for 2.6.34, thank you!
> > > 
> > 
> > Seems neither you nor Jens queued this patch...
> 
> I've included it now, thanks.

<red face>  Thank you both for catching this one!!!

							Thanx, Paul
