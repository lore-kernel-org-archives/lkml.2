Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2GBIBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:01:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35558 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2GBIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:01:39 -0400
Message-ID: <4FF1555C.7020901@linaro.org>
Date: Mon, 02 Jul 2012 12:01:32 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@redhat.com>, linaro-dev@lists.linaro.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Sartain <mikesart@valvesoftware.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Pierre-Loup A. Griffais" <pgriffais@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/7] perf/core improvements and fixes
References: <1340824854-3005-1-git-send-email-acme@infradead.org> <20120629131253.GA395@gmail.com>
In-Reply-To: <20120629131253.GA395@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:12 PM, Ingo Molnar wrote:

> Pulled, thanks Arnaldo!

As of ca24a145573124732152daff105ba68cc9a2b545, 'perf sched replay' is still broken
(but 'perf report' works) if perf.data was recorded on another machine. For example,
native replay is:

run measurement overhead: 0 nsecs
sleep measurement overhead: 112071 nsecs
the run test took 1007080 nsecs
the sleep test took 1159668 nsecs
nr_run_events:        141
nr_sleep_events:      147
nr_wakeup_events:     73
target-less wakeups:  25
multi-target wakeups: 2
task      0 (           <unknown>:      4645), nr_events: 4
task      1 (                perf:      4646), nr_events: 190
task      2 (           swapper/1:         0), nr_events: 33
task      3 (         kworker/1:1:        20), nr_events: 126
task      4 (                sshd:      1881), nr_events: 32
task      5 (             kswapd0:       388), nr_events: 3
------------------------------------------------------------
#1  : 29.663, ravg: 29.66, cpu: 54.38 / 54.38
#2  : 28.442, ravg: 29.54, cpu: 53.38 / 54.28
#3  : 28.564, ravg: 29.44, cpu: 54.02 / 54.26
#4  : 28.290, ravg: 29.33, cpu: 53.50 / 54.18
#5  : 29.877, ravg: 29.38, cpu: 53.16 / 54.08
#6  : 32.227, ravg: 29.67, cpu: 53.74 / 54.04
#7  : 27.588, ravg: 29.46, cpu: 52.67 / 53.91
#8  : 30.762, ravg: 29.59, cpu: 53.44 / 53.86
#9  : 28.381, ravg: 29.47, cpu: 53.04 / 53.78
#10 : 28.473, ravg: 29.37, cpu: 53.71 / 53.77

"Cross-replaying" of the same perf.data is:

run measurement overhead: 65 nsecs
sleep measurement overhead: 55825 nsecs
the run test took 1000140 nsecs
the sleep test took 1064293 nsecs
nr_run_events:        0
nr_sleep_events:      0
nr_wakeup_events:     0
------------------------------------------------------------
#1  : 0.007, ravg: 0.01, cpu: 0.00 / 0.00
#2  : 0.001, ravg: 0.01, cpu: 0.00 / 0.00
#3  : 0.001, ravg: 0.01, cpu: 0.00 / 0.00
#4  : 0.001, ravg: 0.01, cpu: 0.00 / 0.00
#5  : 0.001, ravg: 0.01, cpu: 0.00 / 0.00
#6  : 0.001, ravg: 0.00, cpu: 0.00 / 0.00
#7  : 0.001, ravg: 0.00, cpu: 0.00 / 0.00
#8  : 0.001, ravg: 0.00, cpu: 0.00 / 0.00
#9  : 0.001, ravg: 0.00, cpu: 0.00 / 0.00
#10 : 0.001, ravg: 0.00, cpu: 0.00 / 0.00

Dmitry
