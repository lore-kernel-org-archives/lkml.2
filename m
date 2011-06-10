Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1FJHRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:17:21 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54913 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1FJHRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:17:20 -0400
X-Greylist: delayed 10362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 03:17:20 EDT
X-AuditID: b753bd60-a3c7dba0000050a4-4f-4df1c4fedb33
X-AuditID: b753bd60-a3c7dba0000050a4-4f-4df1c4fedb33
Message-ID: <4DF1C4F4.8030007@hitachi.com>
Date: Fri, 10 Jun 2011 16:17:08 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6> <20110526132833.GC21815@nowhere>
In-Reply-To: <20110526132833.GC21815@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/26 22:28), Frederic Weisbecker wrote:
> (Adding David Ahern in Cc)
>
> Ok that's all good except this needs to use the "perf script" centralized
> dump.
>
> Currently running "perf script" without an actual script dumps
> the events by default, whatever kind of event they are: hardware,
> software, tracepoints, ...
> So we want the branch output to be supported there, so we can reuse
> some code and interface.
>
> For example, "perf script -f branch:comm,tid,sym" would print the
> comm, tid and the sym for to and from addresses.
>
> That's better than creating a new set of options in a new command
> that people need to relearn while everybody could simply get
> familiarized with common perf script options.
>
> Of course we can still have a "perf branch" command, which could
> be a tiny shortcut that maps to perf record and perf script.
>
> Like:
>
> 	perf branch record
> 	perf branch [trace] -f tid,sym,comm
>
> Would map to:
>
> 	perf record branch:u
> 	perf script -f branch:tid,sym,comm
>
> And may be if one day we can do something more tricky than a
> linear output for branches (like source code coloring/browsing),
> then it may be implemented inside perf branch and not rely on
> another subcommand. Until then we are only dealing with raw linear
> dump, and that's a core job for perf script where we want to
> centralize that kind of facility.
OK.
I agreed that the core job is dumpimg BTS logs on perf script.

Next, I'd like to implement the perf-branch's functions and
additional interfaces to perf script.
For example, resoving symbols and dso about branch_to address and,
adding interfaces to get source file path, line number using debuginfo.

I presented about perf-branch's future plan in LinuxCon Japan 2011,
please refer the follwing slide.
http://events.linuxfoundation.org/events/linuxcon-japan/nagai
(The slide will be available soon)


Thank you.

>
> Thanks.
>



