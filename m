Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0EGG5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:57:44 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33961 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0EGG5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:57:43 -0400
Date: Fri, 7 May 2010 08:57:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] blk-cgroup: Fix an RCU warning in blkiocg_create()
Message-ID: <20100507065741.GW27497@kernel.dk>
References: <4BD016F4.8060108@cn.fujitsu.com> <4BD017AC.1020209@cn.fujitsu.com> <20100422195725.GM2524@linux.vnet.ibm.com> <4BE3B985.1000407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE3B985.1000407@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07 2010, Li Zefan wrote:
> Paul E. McKenney wrote:
> > On Thu, Apr 22, 2010 at 05:32:28PM +0800, Li Zefan wrote:
> >> with CONFIG_PROVE_RCU=y, a warning can be triggered:
> >>
> >>   # mount -t cgroup -o blkio xxx /mnt
> >>   # mkdir /mnt/subgroup
> >>
> >> ...
> >> kernel/cgroup.c:4442 invoked rcu_dereference_check() without protection!
> >> ...
> >>
> >> To fix this, we avoid caling css_depth() here, which is a bit simpler
> >> than the original code.
> > 
> > Queued for 2.6.34, thank you!
> > 
> 
> Seems neither you nor Jens queued this patch...

I've included it now, thanks.

-- 
Jens Axboe

