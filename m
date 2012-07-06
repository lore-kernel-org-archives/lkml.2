Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2GFGef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:34:35 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57085 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GFGed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:34:33 -0400
X-AuditID: 9c93016f-b7c7eae0000025c5-7b-4ff686f77d0b
From: Namhyung Kim <namhyung@kernel.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: perf sched replay again
References: <4FF40B7E.20202@linaro.org>
Date: Fri, 06 Jul 2012 15:30:37 +0900
In-Reply-To: <4FF40B7E.20202@linaro.org> (Dmitry Antipov's message of "Wed, 04
	Jul 2012 13:23:10 +0400")
Message-ID: <87k3yhl7ua.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dmitry

On Wed, 04 Jul 2012 13:23:10 +0400, Dmitry Antipov wrote:
> I remember that this was rejected some time ago. Nevertheless,
> is it possible to accept this until we will have a better solution?
>

Why??? 

Ingo already merged da3789628f88 ("perf tools: Stop using a global
trace events description list"). Didn't it solve your problem?

On my tesing, it works well for cross-replay:

  $ ./perf sched -i ~/arm/perf.data replay
  run measurement overhead: 253 nsecs
  sleep measurement overhead: 55136 nsecs
  the run test took 1000013 nsecs
  the sleep test took 1057532 nsecs
  nr_run_events:        53
  nr_sleep_events:      62
  nr_wakeup_events:     31
  target-less wakeups:  1
  task      0 (           <unknown>:      1496), nr_events: 18
  task      1 (                perf:      1497), nr_events: 10
  task      2 (         ksoftirqd/0:         3), nr_events: 9
  task      3 (         kworker/0:1:       280), nr_events: 36
  task      4 (             swapper:         0), nr_events: 62
  task      5 (         sync_supers:       103), nr_events: 3
  task      6 (                init:         1), nr_events: 3
  task      7 (           flush-8:0:       560), nr_events: 3
  task      8 (            rsyslogd:      1135), nr_events: 3
  ------------------------------------------------------------
  #1  : 2664.545, ravg: 2664.54, cpu: 3125.45 / 3125.45
  #2  : 2664.978, ravg: 2664.59, cpu: 3124.99 / 3125.40
  #3  : 2664.736, ravg: 2664.60, cpu: 3125.68 / 3125.43
  #4  : 2664.620, ravg: 2664.60, cpu: 3125.96 / 3125.48
  #5  : 2665.132, ravg: 2664.66, cpu: 3126.02 / 3125.54
  #6  : 2665.096, ravg: 2664.70, cpu: 3083.47 / 3121.33
  #7  : 2665.585, ravg: 2664.79, cpu: 3125.66 / 3121.76
  #8  : 2664.839, ravg: 2664.79, cpu: 3126.01 / 3122.19
  #9  : 2664.750, ravg: 2664.79, cpu: 3125.38 / 3122.51
  #10 : 2668.297, ravg: 2665.14, cpu: 3116.82 / 3121.94
  
Of course, host and arm machine have different id's.

Thanks,
Namhyung
