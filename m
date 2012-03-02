Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215Ab2CBOwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:52:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57899 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab2CBOwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:52:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.216.132 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F50DEA0.2020607@gmail.com>
Date: Fri, 02 Mar 2012 07:52:16 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [tip:perf/core] perf tools: Allow multiple threads or processes
 in record, stat, top
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com> <tip-b52956c961be3a04182ae7b776623531601e0fb7@git.kernel.org> <20120302105620.GA21762@elte.hu>
In-Reply-To: <20120302105620.GA21762@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That first cup of coffee is so important.

On 3/2/12 3:56 AM, Ingo Molnar wrote:
> phoenix:~>  perf record -a sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.023 MB perf.data (~988 samples) ]
> phoenix:~>  perf report --stdio
> Warning:
> The perf.data file has no samples!
> # ========
> # captured on: Fri Mar  2 12:01:41 2012
> # hostname : phoenix
> # os release : 3.3.0-rc5+
> # perf version : 3.3.rc5.1698.g68a63a.dirty
> # arch : x86_64
> # nrcpus online : 16
> # nrcpus avail : 16
> # cpudesc : Quad-Core AMD Opteron(tm) Processor 8356
> # cpuid : AuthenticAMD,16,2,3

Would you mind adding this patch:
   https://lkml.org/lkml/2012/2/29/217
and see if it fixes your problem?

Quick test with an updated tree:
$ /tmp/pbuild/perf record -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.046 MB perf.data (~1990 samples) ]

$ /tmp/pbuild/perf script
<samples dumped>

$ /tmp/pbuild/perf --version
perf version perf.core.for.mingo.36.g8eedce

This is your tip.git repository, tip/perf/core branch:

[remote "tip"]
     url = git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
     fetch = +refs/heads/*:refs/remotes/tip/*
[branch "tip-perf-core"]
     remote = tip
     merge = refs/heads/perf/core

I did noticed that this branch only shows 3.3.0-rc2 as the latest kernel 
version.

> # total memory : 33012240 kB
> # cmdline : /home/mingo/bin/perf record -a sleep 1
> # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_k
> # HEADER_CPU_TOPOLOGY info available, use -I to display
> # HEADER_NUMA_TOPOLOGY info available, use -I to display
> # ========
> phoenix:~>  perf --version
> perf version 3.3.rc5.1698.g68a63a.dirty
> phoenix:~>
>
> The later fixes to b52956c9, such as:
>
>    6b1bee9035d4: perf tools: fix broken perf record -a mode
>
> did not fix this system - it's still broken as of today's -tip.
>
> Another system running the same kernel does not exhibit this
> problem, so it's somehow specific to this system.

Is the other system Intel based?

David
