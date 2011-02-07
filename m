Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1BGMUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:20:31 -0500
Received: from core.kaist.ac.kr ([143.248.147.118]:41310 "EHLO
	core.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1BGMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:20:30 -0500
X-Greylist: delayed 3364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 07:20:27 EST
From: "Chulmin Kim" <cmkim@core.kaist.ac.kr>
To: "'Daniel Tiron'" <dtiron@debian.armed.us>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
References: <20110207095141.GA26132@andariel.informatik.uni-erlangen.de>
In-Reply-To: <20110207095141.GA26132@andariel.informatik.uni-erlangen.de>
Subject: RE: Does the scheduler know about the cache topology?
Date: Mon, 7 Feb 2011 20:24:07 +0900
Message-ID: <02c101cbc6b9$8aa68790$9ff396b0$@core.kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQG6GfuaJL4YZPy5XJ3iPIY+m6k3+pQZPPog
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know, linux scheduler manages the physical cores using
sched_domain. 

Simply speaking, Sched_domain is a group of cpus. And the load balancing is
usually done within the group. 
(this group is hierarchical tree. you can find more specific information
about this structure in web)

This grouping can be done by SMT, NUMA and cache topology through ACPI
information obtained when the system is booted.

Hope this is useful for you.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Daniel Tiron
Sent: Monday, February 07, 2011 6:52 PM
To: LKML
Subject: Does the scheduler know about the cache topology?

Hi all.

I did some performance tests on a Core 2 Quad machine [1] with QEMU.
A QEMU instance creates one main thread and one thread for each virtual CPU.
There were two vms with one CPU each, which make four threads.

I tried different combinations where I pinned one tgread to one physical
core with taskset and measured the network performance between the vms with
iperf [2]. The best result was achieved with each vm (main and CPU
thread) assigned to one cache group (core 0 & 1 and 2 & 3).

But it also turns out that letting the scheduler handle the assignment works
well, too: The results where no pinning was done were just slightly below
the best. So I was wondering, is the Linux scheduler aware of the CPU's
cache topology?

I'm curious to hear your opinion.

Thanks,
Daniel

[1] Core 0 and 1 share one L2 cache and so do 2 and 3 [2] The topic of my
research is networking performance. My interest in
    cache awareness is only a side effect.

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

