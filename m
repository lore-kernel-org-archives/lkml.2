Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab1KWPT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:19:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab1KWPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:19:24 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=bix7J2-88xUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=slFahur0PUGST9eQeVQA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/2] trace_event_filter: factorize filter creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20111123020016.GB19630@google.com>
References: <20111123014603.GA19630@google.com>
	 <20111123020016.GB19630@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 10:19:21 -0500
Message-ID: <1322061561.20742.53.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 18:00 -0800, Tejun Heo wrote:
> There are four places where new filter for a given filter string is
> created, which involves several different steps.  This patch factors
> those steps into create_[system_]filter() functions which in turn make
> use of create_filter_{start|finish}() for common parts.
> 
> The only functional change is that if replace_filter_string() is
> requested and fails, creation fails without any side effect instead of
> being ignored.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> These two are on top of the current linus/master bbbc4791cd "Merge
> branch 'staging-linus' of git://git.kernel.org/.../gregkh/staging" as
> tip seems to be lagging behind for the moment.
> 
> Thank you.
> 
>  kernel/trace/trace_events_filter.c |  274 ++++++++++++++++++-------------------
>  1 file changed, 137 insertions(+), 137 deletions(-)

For such a change, I would have liked to see more deletions than
insertions. Although, if it removes duplicate code, I'm not against such
a change. I'll look at this more when I get some more time. But just in
case I forget about it (because I wont look at it before my turkey
dinner tomorrow, and will most likely forget about it come next Monday),
please feel free to ping me again next week.

-- Steve



