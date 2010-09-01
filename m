Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0IALKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:10:32 -0400
Received: from mx.ij.cx ([212.13.201.15]:59154 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752379Ab0IALKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:10:30 -0400
Date: Wed, 1 Sep 2010 12:10:23 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: cgroup: rmdir() does not complete
In-Reply-To: <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz> <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp> <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com> <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
 <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, KAMEZAWA Hiroyuki wrote:

> On Fri, 27 Aug 2010 12:39:48 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Fri, 27 Aug 2010 11:35:06 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Fri, 27 Aug 2010 09:56:39 +0900
> > > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > 
> > > > > Or is it likely to be some other cause, and how best to find it?
> > > > > 
> > > > What cgroup subsystem did you mount where the directory existed you tried
> > > > to rmdir() first ?
> > > > If you mounted several subsystems on the same hierarchy, can you mount them
> > > > separately to narrow down the cause ?
> > > > 
> > > 
> > > It seems I can reproduce the issue on mmotm-0811, too.
> > > 
> > > try this.
> > > 
> > > Here, memory cgroup is mounted at /cgroups.
> > > ==
> > > #!/bin/bash -x
> > > 
> > > while sleep 1; do
> > >         date
> > >         mkdir /cgroups/test
> > >         echo 0 > /cgroups/test/tasks
> > >         echo 300M > /cgroups/test/memory.limit_in_bytes
> > >         cat /proc/self/cgroup
> > >         dd if=/dev/zero of=./tmpfile bs=4096 count=100000
> > >         echo 0 > /cgroups/tasks
> > >         cat /proc/self/cgroup
> > >         rmdir /cgroups/test
> > >         rm ./tmpfile
> > > done
> > > ==
> > > 
> > > hangs at rmdir. I'm no investigating force_empty.
> > > 
> > Thank you very much for your information.
> > 
> > Some questions.
> > 
> > Is "tmpfile" created on a normal filesystem(e.g. ext3) or tmpfs ?
> on ext4.
> 
> > And, how long does it likely to take to cause this problem ?
> 
> very soon. 10-20 loop.

I repeated the test above, but did not see a problem after many hundreds 
of loops.

My test was with the same kernel from my original bug report (Fedora 
2.6.33.6-147), using memory cgroup only and ext4 filesystem.

So it is possible we are experiencing different bugs with similar 
symptoms.

-- 
Mark
