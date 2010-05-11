Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0EKFv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:51:58 -0400
Received: from ozlabs.org ([203.10.76.45]:49246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab0EKFv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:51:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] cpumask: fix compat getaffinity
Date: Tue, 11 May 2010 15:21:52 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Ken Werner <ken.werner@web.de>, Andi Kleen <andi@firstfloor.org>,
       stable@kernel.org
References: <201005081111.08720.arnd@arndb.de> <20100511104334.E572.A69D9226@jp.fujitsu.com> <20100511031354.GA9327@kroah.com>
In-Reply-To: <20100511031354.GA9327@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005111521.53135.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 12:43:54 pm Greg KH wrote:
> On Tue, May 11, 2010 at 10:47:03AM +0900, KOSAKI Motohiro wrote:
> > > How's this?
> > > 
> > > cpumask: use nr_cpu_ids for printing and parsing cpumasks
> > > 
> > > Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> > > libnuma, which abuses sched_getaffinity to find out NR_CPUS
> > > in order to parse /sys/devices/system/node/node*/cpumap.
> > > 
> > > However, the result now returned reflects nr_cpu_ids, and
> > > cpumask_scnprintf et al. use nr_cpumask_bits which is NR_CPUS (for
> > > CONFIG_CPUMASK_OFFSTACK=n) or nr_cpu_ids (for
> > > CONFIG_CPUMASK_OFFSTACK=y).
> > > 
> > > We should use nr_cpu_ids consistently.
> > >
> > > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > Cc: stable@kernel.org
> > 
> > Well, This patch seems to have ABI change. please don't send abi-change to -stable.
> 
> Why?  There is no such thing as a "stable" internal abi in the kernel,
> and that includes the -stable kernel releases.

He's referring to the change in sysfs output.  However, the ABI involved is
already defined to be robust against change of NR_CPUS, so changing it to
nr_cpu_ids is OK.

Of course, if libnuma weren't abusing the ABI, this change wouldn't be
necessary :(

Cheers,
Rusty.
