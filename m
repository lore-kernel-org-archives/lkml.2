Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1KBSWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:22:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1KBSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:22:49 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=DJOu6W8zkUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=d91OG6ziQ8P09lIm3SsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320258167.4793.45.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Restore system filter behavior
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 Nov 2011 14:22:47 -0400
In-Reply-To: <4EAF46CF.8040408@cn.fujitsu.com>
References: <4EAF46CF.8040408@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 09:09 +0800, Li Zefan wrote:
> Though not all events have field 'prev_pid', it was allowed to do this:
> 
>   # echo 'prev_pid == 100' > events/sched/filter
> 
> but commit 75b8e98263fdb0bfbdeba60d4db463259f1fe8a2 (tracing/filter: Swap
> entire filter of events) broke it without any reason.

I wouldn't say "without any reason" as there was a reason.

But I'm not pleased with the way this all works still.

# echo 'prev_pid == 100' > /debug/tracing/events/sched/filter
# cat /debug/tracing/events/sched/filter
prev_pid == 100

# cat /debug/tracing/events/sched/sched_migrate_task/filter
none

# echo 'orig_cpu == 1' > /debug/tracing/events/sched/sched_migrate_task/filter
# cat /debug/tracing/events/sched/sched_migrate_task/filter
orig_cpu == 1

# cat /debug/tracing/events/sched/filter
prev_pid == 100


The above shows how things are just ambiguous. I have no problem in
using the top filter to set multiple events. But the top filter should
not keep the state of what was set. Perhaps just have system event
filters always show default text. Like:

# cat /debug/tracing/events/sched/filter
### global filter ###
# Use this to set multiple event filters
# Only affects events that have the event fields specified in the filter


I'll add your patch, but are you OK with the above always printing for
system event filters?  Just to remove the ambiguous state.

-- Steve


