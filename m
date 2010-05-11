Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0EKPvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:51:13 -0400
Received: from kroah.org ([198.145.64.141]:55784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab0EKPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:51:08 -0400
Date: Tue, 11 May 2010 08:20:02 -0700
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Ken Werner <ken.werner@web.de>,
       Andi Kleen <andi@firstfloor.org>, stable@kernel.org
Subject: Re: [stable] cpumask: fix compat getaffinity
Message-ID: <20100511152002.GB16561@kroah.com>
References: <20100511104334.E572.A69D9226@jp.fujitsu.com>
 <20100511031354.GA9327@kroah.com>
 <20100511151526.E578.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511151526.E578.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 03:20:45PM +0900, KOSAKI Motohiro wrote:
> > On Tue, May 11, 2010 at 10:47:03AM +0900, KOSAKI Motohiro wrote:
> > > > How's this?
> > > > 
> > > > cpumask: use nr_cpu_ids for printing and parsing cpumasks
> > > > 
> > > > Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> > > > libnuma, which abuses sched_getaffinity to find out NR_CPUS
> > > > in order to parse /sys/devices/system/node/node*/cpumap.
> > > > 
> > > > However, the result now returned reflects nr_cpu_ids, and
> > > > cpumask_scnprintf et al. use nr_cpumask_bits which is NR_CPUS (for
> > > > CONFIG_CPUMASK_OFFSTACK=n) or nr_cpu_ids (for
> > > > CONFIG_CPUMASK_OFFSTACK=y).
> > > > 
> > > > We should use nr_cpu_ids consistently.
> > > >
> > > > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > > Cc: stable@kernel.org
> > > 
> > > Well, This patch seems to have ABI change. please don't send abi-change to -stable.
> > 
> > Why?  There is no such thing as a "stable" internal abi in the kernel,
> > and that includes the -stable kernel releases.
> > 
> > If it fixes a bug, that's all the requirement is.
> 
> AFAIK, -stable is mainly used for distro and they have many and many
> packages. we can't assume no app read /sys files directly.
> IOW, To change /sys printing format is a bit risky change. frequently
> compatibility breaking natually break code stability.

Ah, the sysfs user/kernel API is what you are referring to here, right?
If so, remember, any changes need to be documented in Documentation/API
:)

And as for distros using -stable for their releases, that's fine, they
well know the risks/benefits for that and handle changes on their own.

thanks,

greg k-h
