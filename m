Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab2AFWG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 17:06:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2AFWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 17:06:27 -0500
Date: Fri, 6 Jan 2012 14:06:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: David Rientjes <rientjes@google.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups:
 disallow attaching kthreadd
Message-Id: <20120106140625.f5447039.akpm@linux-foundation.org>
In-Reply-To: <1323232617.5057.50.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net>
	<alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	<1316770936.6641.11.camel@marge.simson.net>
	<1316775204.7562.9.camel@marge.simson.net>
	<alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	<1316788392.6544.33.camel@marge.simson.net>
	<1318224892.6161.45.camel@marge.simson.net>
	<1318233815.6527.5.camel@marge.simson.net>
	<1318925436.9641.23.camel@marge.simson.net>
	<CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
	<1319001860.6222.34.camel@marge.simson.net>
	<alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com>
	<20111206144721.7b1d473d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
	<1323227914.5057.10.camel@marge.simson.net>
	<1323232617.5057.50.camel@marge.simson.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Dec 2011 05:36:57 +0100
Mike Galbraith <efault@gmx.de> wrote:

> cpusets, cgroups: disallow attaching kthreadd
> 
> Allowing kthreadd to be moved to a non-root group makes no sense, it being
> a global resource, and needlessly leads unsuspecting users toward trouble.
> 
> 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> allocated is not schedulable.  Simple user error, but harmful to the box.
> 
> 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> rendering the cpuset immortal.
> 
> Save the user some unexpected trouble, just say no.

Someone's been screwing around in linux-next during the merge window. 
afacit some patch which was previously there has magically disappeared.
That killed your patch - the original version of the
kernel/sched/core.c chagne applies to the new linux-next but the
kernel/cpuset.c part is all wrecked.

There's been a lot of screwing around this time.  There were a large
number of rejects merging current linux-next onto current mainline this
morning due to conflicting changes in tools/perf/.

