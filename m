Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2GTTYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:24:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2GTTYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:24:36 -0400
Date: Fri, 20 Jul 2012 14:24:24 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Charles Wang'" <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?utf-8?B?J+WQq+m7myc=?= <handai.szj@taobao.com>,
        linux-doc@vger.kernel.org
Subject: sched: care and feeding of load-avg code (Re: [PATCH] sched: Folding
 nohz load accounting more accurate)
Message-ID: <20120720192424.GA4726@burratino>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
 <1339429374.30462.54.camel@twins>
 <4FD70D12.5030404@gmail.com>
 <1339494970.31548.66.camel@twins>
 <004701cd4929$200d4600$6027d200$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004701cd4929$200d4600$6027d200$@net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Doug Smythies wrote:

> On my computer, and from a different thread from yesterday, I let
> the proposed "wang" patch multiple processes test continue for
> another 24 hours. The png file showing the results is attached, also
> available at [1].
[...]
> http://www.smythies.com/~doug/network/load_average/load_processes_wang.html

Thanks.

Now that a nice patch seems to be available that takes care of
everything :), it seems like a good moment to make sure that the next
time there are scheduler changes people can easily see what they need
to do.

That is, what information would someone new to this code benefit from
in order to keep it working well?

I am particularly interested in making sure your tests don't get lost.
How about something like this?

-- >8 --
Subject: sched: add skeleton load-avg documentation

For now this is just a link to
http://www.smythies.com/~doug/network/load_average/ which has some
useful examples of how to test changes.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 Documentation/scheduler/00-INDEX       |    2 ++
 Documentation/scheduler/sched-load.txt |   16 ++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 Documentation/scheduler/sched-load.txt

diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
index d2651c47ae27..99c75547282d 100644
--- a/Documentation/scheduler/00-INDEX
+++ b/Documentation/scheduler/00-INDEX
@@ -6,6 +6,8 @@ sched-design-CFS.txt
 	- goals, design and implementation of the Completely Fair Scheduler.
 sched-domains.txt
 	- information on scheduling domains.
+sched-load.txt
+	- how load-average code works and how to keep it working.
 sched-nice-design.txt
 	- How and why the scheduler's nice levels are implemented.
 sched-rt-group.txt
diff --git a/Documentation/scheduler/sched-load.txt b/Documentation/scheduler/sched-load.txt
new file mode 100644
index 000000000000..16599993d5aa
--- /dev/null
+++ b/Documentation/scheduler/sched-load.txt
@@ -0,0 +1,16 @@
+load averages
+=============
+
+Reported load averages are by necessity an approximation, but with
+care we can make sure they approximate reality most of the time.
+
+Talk about kernel/sched/core.c, including:
+
+* what is the expected load average?
+* workloads to test, automated testing
+* known problems, e.g. limitations due to finite-precision math
+* interaction with CPU frequency scaling
+* relevant links such as
+  http://www.smythies.com/~doug/network/load_average/
+
+(Peter Zijlstra, Doug Smythies, Charles Wang)
-- 
1.7.10.4

