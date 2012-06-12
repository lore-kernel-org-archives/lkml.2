Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2FLHKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:10:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57589 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2FLHJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:09:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD6EACE.9010109@jp.fujitsu.com>
Date: Tue, 12 Jun 2012 16:07:58 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ron Chen <ron_chen_123@yahoo.com>
CC: Linux Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: memcg cgroup controller & sbrk interaction
References: <1339118347.78794.YahooMailNeo@web112018.mail.gq1.yahoo.com>
In-Reply-To: <1339118347.78794.YahooMailNeo@web112018.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/08 10:19), Ron Chen wrote:
> We are from the Open Grid Scheduler, which is the official Open Source Grid Engine. Open Grid Scheduler/
> Grid Engine ( http://gridscheduler.sourceforge.net ) is used by many compute farms&  HPC sites for job scheduling.
> 
> In the next release, we are using cgroups to define a Job Container interface for batch jobs:
> 
> http://blogs.scalablelogic.com/2012/05/grid-engine-cgroups-integration.html
> 
> 
> However, not only us, but others have found that the memcg controller does not cause sbrk(2) or mmap(2) to
> return error when the cgroup is under high memory pressure. Further, when the amount of free memory is
> really low, the Linux Kernel OOM killer picks something and kills it.
> 
> http://www.spinics.net/lists/cgroups/msg02622.html
> 
> 
> We also would like to see if it is technically possible for the Virtual Memory Manager to interact with the
> memory controller properly and give us the semantics of setrlimit(2). So basically if the current address
> space usage exceeds the "memory.memsw.limit_in_bytes" limit defined by the administrator, then the
> memory allocation system calls (example: mmap(2), sbrk(2), etc) will return error such that the OOM
> killer is not invoked.
> 

It's not implemented yet. And, it was proposed before and patches were posted but
finally didn't be merged.

IIRC, there were some implementation problem but the biggest reason of rejection
was the author couldn't convince us there are real use case.

If you have real use case and want a new feature on memory cgroup, please CC
cgroups@vger.kernel.org, linux-mm@kvack.org
Someone (including me) may be able to cook a patch for future linux kernel if you
have real use cases.

BTW, you can stop memory-cgroup-level oom-killer by memory.oom_control file.
But you cannot stop system-level oom-killer, there are no knobs.

Thanks,
-Kame

