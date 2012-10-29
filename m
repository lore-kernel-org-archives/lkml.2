Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab2J2QBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:01:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41973 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601Ab2J2QBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:01:51 -0400
MIME-Version: 1.0
Date: Mon, 29 Oct 2012 12:01:51 -0400
Message-ID: <CAPhKKr8HAbAw2jdvva6oJYj747ZS0dTakz2=qJXN+NsTiu=dCg@mail.gmail.com>
Subject: [BUG] perf report: different reports when run on terminal as opposed
 to script
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Arnaldo de Melo <acme@infradead.org>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, namhyung@kernel.org
Cc: akshay kumar <iit.akshay@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As part of a class assignment I have to collect some performance
statistics. In order to do so I run

perf record -g <the program I have to profile>

And in another window, I start 200 threads of the load generator
(which is not recorded by perf)

This generates me statistics that I expect to see, and I am happy. As
this is academia and a class assignment, I need to collect information
and analyze it across different setups. Which of course meant I script
this whole thing, which basically is

for i in all possibilities
do
perf record -g <the program I have to profile> &
WAITPID=$!
for j in NR_THREADS
do
<start load generator> &
KILLPID=$!
done
wait $PID
kill $KILLPID
mv perf.data results/perf.data.$i
done

(This is basic pseudo script of what I am doing), which results me
having my profile being topped by _vscanf() and the function which I
was seeing dominating in the older report dropping down to something
like 5% (as opposed to 16-17%)

Have I misunderstood how perf works? Something deeper? I am currently
on 3.6.3. I can update to the latest upstream and report back. Any
debug code is very welcome. I can also make my toy program and the
scripts available for you to try out.

Thanks!
Dhaval
