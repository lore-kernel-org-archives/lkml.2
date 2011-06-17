Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab1FQOe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:34:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab1FQOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:34:28 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=Caq5pGLvaXcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=lAZbC83loSnbg07b5o4A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority
 changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
	 <1308275405.9218.156.camel@gandalf.stny.rr.com>
	 <BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 17 Jun 2011 10:34:25 -0400
Message-ID: <1308321265.9218.175.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 20:59 +0800, Hillf Danton wrote:

> > We do the calculation on queuing and dequeuing the task, we only care
> > about the highest priority task that is on the queue, not what is
> > actually running.
> >
> 
> It is to capture the changes in CPU priority caused by re-queued task and
> throttled RQ.

If we throttled the rq, then the fix up should happen in the
(en,de)queue code, and not scattered around.

I'll look deeper into how throttling affects the cpupri.

-- Steve


