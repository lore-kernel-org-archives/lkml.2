Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab0EKGZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:25:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50826 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab0EKGZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:25:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [stable] cpumask: fix compat getaffinity
Cc: kosaki.motohiro@jp.fujitsu.com, Greg KH <greg@kroah.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Ken Werner <ken.werner@web.de>, Andi Kleen <andi@firstfloor.org>,
       stable@kernel.org
In-Reply-To: <201005111521.53135.rusty@rustcorp.com.au>
References: <20100511031354.GA9327@kroah.com> <201005111521.53135.rusty@rustcorp.com.au>
Message-Id: <20100511152229.E57B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 11 May 2010 15:25:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 11 May 2010 12:43:54 pm Greg KH wrote:
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
> 
> He's referring to the change in sysfs output.  However, the ABI involved is
> already defined to be robust against change of NR_CPUS, so changing it to
> nr_cpu_ids is OK.

hmm...

ok, I'm cancel my previous claim. generically I think I'm right. but in this case
I agree the patch's risk is very low.

sorry for noise.

> Of course, if libnuma weren't abusing the ABI, this change wouldn't be
> necessary :(

yes yes...




