Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0H0Dlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 23:41:46 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51944 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0H0Dlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 23:41:44 -0400
Date: Fri, 27 Aug 2010 12:39:48 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mark Hills <mark@pogo.org.uk>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: cgroup: rmdir() does not complete
Message-Id: <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
	<20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
	<20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 11:35:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 27 Aug 2010 09:56:39 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > > Or is it likely to be some other cause, and how best to find it?
> > > 
> > What cgroup subsystem did you mount where the directory existed you tried
> > to rmdir() first ?
> > If you mounted several subsystems on the same hierarchy, can you mount them
> > separately to narrow down the cause ?
> > 
> 
> It seems I can reproduce the issue on mmotm-0811, too.
> 
> try this.
> 
> Here, memory cgroup is mounted at /cgroups.
> ==
> #!/bin/bash -x
> 
> while sleep 1; do
>         date
>         mkdir /cgroups/test
>         echo 0 > /cgroups/test/tasks
>         echo 300M > /cgroups/test/memory.limit_in_bytes
>         cat /proc/self/cgroup
>         dd if=/dev/zero of=./tmpfile bs=4096 count=100000
>         echo 0 > /cgroups/tasks
>         cat /proc/self/cgroup
>         rmdir /cgroups/test
>         rm ./tmpfile
> done
> ==
> 
> hangs at rmdir. I'm no investigating force_empty.
> 
Thank you very much for your information.

Some questions.

Is "tmpfile" created on a normal filesystem(e.g. ext3) or tmpfs ?
And, how long does it likely to take to cause this problem ?
I've run it on RHEL6-based kernel/ext3 for about one hour, but
I cannot reproduce it yet.


Thanks,
Daisuke Nishimura.
