Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0ELAwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:52:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46175 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0ELAwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:52:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: cpumask: fix compat getaffinity
Cc: kosaki.motohiro@jp.fujitsu.com, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>
In-Reply-To: <201005111105.03475.arnd@arndb.de>
References: <201005110913.49162.rusty@rustcorp.com.au> <201005111105.03475.arnd@arndb.de>
Message-Id: <20100512094938.2129.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 12 May 2010 09:52:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tuesday 11 May 2010, Rusty Russell wrote:
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
> It looks like this changes fixes the compat case, but now
> the native system call would be inconsistent with the
> sysfs output. 
> 
> Wouldn't you also need something like the change below
> to make the return value of sched_getaffinity() independent
> of NR_CPUS?
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good. but please rebase it on latest linus-tree. in linus tree,
we are already using nr_cpu_ids instead NR_CPUS.

And I'm sorry. at making such change, I've forgot to care compat
syscall, your patch fixes it ;)



