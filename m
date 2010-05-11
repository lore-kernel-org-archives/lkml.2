Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0EKDRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:17:14 -0400
Received: from kroah.org ([198.145.64.141]:36562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0EKDRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:17:12 -0400
Date: Mon, 10 May 2010 20:13:54 -0700
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Ken Werner <ken.werner@web.de>,
       Andi Kleen <andi@firstfloor.org>, stable@kernel.org
Subject: Re: [stable] cpumask: fix compat getaffinity
Message-ID: <20100511031354.GA9327@kroah.com>
References: <201005081111.08720.arnd@arndb.de> <201005110913.49162.rusty@rustcorp.com.au> <20100511104334.E572.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511104334.E572.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 10:47:03AM +0900, KOSAKI Motohiro wrote:
> > How's this?
> > 
> > cpumask: use nr_cpu_ids for printing and parsing cpumasks
> > 
> > Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> > libnuma, which abuses sched_getaffinity to find out NR_CPUS
> > in order to parse /sys/devices/system/node/node*/cpumap.
> > 
> > However, the result now returned reflects nr_cpu_ids, and
> > cpumask_scnprintf et al. use nr_cpumask_bits which is NR_CPUS (for
> > CONFIG_CPUMASK_OFFSTACK=n) or nr_cpu_ids (for
> > CONFIG_CPUMASK_OFFSTACK=y).
> > 
> > We should use nr_cpu_ids consistently.
> >
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: stable@kernel.org
> 
> Well, This patch seems to have ABI change. please don't send abi-change to -stable.

Why?  There is no such thing as a "stable" internal abi in the kernel,
and that includes the -stable kernel releases.

If it fixes a bug, that's all the requirement is.

> note: I'm not against this patch itself.

Great, then it should be just fine, right?

thanks,

greg k-h
