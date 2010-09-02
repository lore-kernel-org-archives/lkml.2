Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0IBJpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 05:45:14 -0400
Received: from mx.ij.cx ([212.13.201.15]:52499 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868Ab0IBJpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:45:12 -0400
Date: Thu, 2 Sep 2010 10:45:01 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: cgroup: rmdir() does not complete
In-Reply-To: <20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.NEB.2.01.1009021012360.22833@jrf.vwaro.pbz>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz> <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp> <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com> <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp> <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz> <20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, KAMEZAWA Hiroyuki wrote:

> On Wed, 1 Sep 2010 12:10:23 +0100 (BST)
> Mark Hills <mark@pogo.org.uk> wrote:
[...]
> > I repeated the test above, but did not see a problem after many hundreds 
> > of loops.
> > 
> > My test was with the same kernel from my original bug report (Fedora 
> > 2.6.33.6-147), using memory cgroup only and ext4 filesystem.
> > 
> > So it is possible we are experiencing different bugs with similar 
> > symptoms.
> > 
> 
> Thank you for confirming.
> But hmm...it's curious who holds mutex and what happens.

Refer to my original email, where I was running multiple tests at once. 
This backtrace is from the tests which queue up:

  Call Trace:
  [<ffffffff81115edb>] ? mntput_no_expire+0x24/0xe7
  [<ffffffff81427acd>] __mutex_lock_common+0x14d/0x1b4
  [<ffffffff81108a7c>] ? path_put+0x1d/0x22
  [<ffffffff81427b48>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff81427c4f>] mutex_lock+0x31/0x4b
  [<ffffffff8110bdf8>] do_rmdir+0x74/0x102
  [<ffffffff8110bebd>] sys_rmdir+0x11/0x13
  [<ffffffff81009b02>] system_call_fastpath+0x16/0x1b

The one which spins has already managed to claim the mutex lock on the 
/cgroup directory, and no call trace is shown for this. Is there a usable 
way to force a similar call trace for the spinning process?

Unfortunately I have not been able to reproduce the problem for some days 
now, so I think some network factor is able to influence this.

-- 
Mark
