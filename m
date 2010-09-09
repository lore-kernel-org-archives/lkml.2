Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0IILg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:36:59 -0400
Received: from mx.ij.cx ([212.13.201.15]:51290 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751408Ab0IILg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:36:58 -0400
Date: Thu, 9 Sep 2010 12:36:51 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: cgroup: rmdir() does not complete
In-Reply-To: <20100909100909.GM4443@balbir.in.ibm.com>
Message-ID: <alpine.NEB.2.01.1009091234230.26366@jrf.vwaro.pbz>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz> <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp> <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com> <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp> <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz> <20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com> <alpine.NEB.2.01.1009091051400.17759@jrf.vwaro.pbz> <20100909100909.GM4443@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Balbir Singh wrote:

> * Mark Hills <mark@pogo.org.uk> [2010-09-09 11:01:45]:
> 
> > On Thu, 2 Sep 2010, KAMEZAWA Hiroyuki wrote:
> > 
> > [...]
> > > But hmm...it's curious who holds mutex and what happens.
> > 
> > I have a system showing the failure case (but still do not have a way to 
> > reliably repeat it)
> > 
> > Here are the two processes:
> > 
> > 23586 pts/0    RL+  5059:18 /net/homes/mhills/tmp/soaked-cgroup
> > 23685 pts/6    DL+    0:00 /net/homes/mhills/tmp/soaked-cgroup
> > 
> > 23586 spends almost all of its time in 'RL+' status, occasionally it is 
> > seen in 'DL+' status.
> > 
> > From my analysis before, both are blocked on rmdir(), but one is spinning, 
> > holding the lock on the /cgroup, and the other is waiting for the lock. If 
> > I strace 23586 then the rmdir() fails with EINTR.
> >
> 
> Any chance you can compile with debug cgroup subsystem and get
> information from there? 

I can, I'd like to experiment with a custom kernel next.

I am still finding the problem incredibly hard to reproduce, so I'd like 
to observe as much data as possible from the current case before 
rebooting. If I could capture some kind of stack trace in the kernel for 
the running process that would be great, any suggestions appreciated.

Thanks

-- 
Mark
