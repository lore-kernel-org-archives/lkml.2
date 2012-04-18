Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2DRSdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:33:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2DRSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:32:58 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=JomeGkWH5N8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=NXGx4cpFtuKCEL7X5GYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334773976.28106.49.camel@gandalf.stny.rr.com>
Subject: Re: [sched/rt] Optimization of function pull_rt_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 18 Apr 2012 14:32:56 -0400
In-Reply-To: <1334592379.28106.4.camel@gandalf.stny.rr.com>
References: <1334519122.8698.3.camel@hp>
	 <1334592379.28106.4.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 12:06 -0400, Steven Rostedt wrote:
> On Sun, 2012-04-15 at 23:45 +0400, Kirill Tkhai wrote:
> > The condition (src_rq->rt.rt_nr_running) is weak because it doesn't
> > consider the cases when src_rq has only processes bound to it (when
> > single cpu is allowed). It may be running kernel thread like
> > migration/x etc.
> > 
> > So it's better to use more stronger condition which is able to exclude
> > above conditions. The function has_pushable_tasks() complitely does
> > this. A task may be pullable for another cpu rq only if he is pushable
> > for his own queue.
> 
> I considered this before, and for some reason I never did the change.
> I'll have to think about it. It seems like this would be the obvious
> case, but I think there was something not so obvious that caused issues.
> But I don't remember what it was.
> 
> I'll have to rethink this again.

I can't find anything wrong with this change. Maybe things change, or I
was thinking of another change.

I'll apply it and start running my tests against it.

Thanks!

-- Steve

