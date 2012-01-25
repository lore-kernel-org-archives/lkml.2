Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2AYUQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:16:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2AYUQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:16:01 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=LLHFQ_wfPagA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=jXwhQv3-BEqAQUkhdQgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327522558.22710.47.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
From: Steven Rostedt <rostedt@goodmis.org>
To: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 25 Jan 2012 15:15:58 -0500
In-Reply-To: <4F205D1D.1020304@fb.com>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
	 <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>
	 <1327352631.2446.22.camel@twins> <4F1DE6FE.4000603@fb.com>
	 <1327415255.2614.33.camel@laptop> <4F1F26CC.4040109@fb.com>
	 <20120125092008.GB20878@somewhere> <4F205D1D.1020304@fb.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 11:50 -0800, Arun Sharma wrote:

> # perf record -agP -e sched:sched_switch --filter "prev_state == 1 || 
> prev_state == 2" -e  sched:sched_stat_sleep -- sleep 3
> [ perf record: Woken up 107 times to write data ]
> [ perf record: Captured and wrote 32.629 MB perf.data (~1425585 samples) ]
> Warning:
> Processed 104066 events and lost 4 chunks!
> 
> Check IO/CPU overload!

Just for kicks, could you try trace-cmd?

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

trace-cmd record -e sched_switch -f 'prev_state == 1 || prev_state == 2' -e sched_stat_sleep sleep 3

I'm not sure the filter is even needed, and it should still keep up
fine.

-- Steve


