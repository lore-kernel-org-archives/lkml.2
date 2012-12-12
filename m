Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2LLODT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:03:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2LLODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:03:16 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cU5zP3iA40MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wzXg5rMBBV8A:10 a=vZ9LEm3PqLCLqgcXqy0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355320994.17101.326.camel@gandalf.local.home>
Subject: Re: [RFC PATCH] sched: rt: fix selecting runqueue for task to be
 pushed
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Dec 2012 09:03:14 -0500
In-Reply-To: <CAJd=RBBLLtOCwVipcKD3g6xRWgVcfWi1q5m6p4TmwAcgOCh+4Q@mail.gmail.com>
References: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
	 <1355149273.17101.176.camel@gandalf.local.home>
	 <CAJd=RBDprA5ruzY6-uQ3L5eSX3Muk8fSpQZbbmsK0oAGwk0WtQ@mail.gmail.com>
	 <1355277274.17101.323.camel@gandalf.local.home>
	 <1355280374.17101.325.camel@gandalf.local.home>
	 <CAJd=RBBLLtOCwVipcKD3g6xRWgVcfWi1q5m6p4TmwAcgOCh+4Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 19:44 +0800, Hillf Danton wrote:
> On Wed, Dec 12, 2012 at 10:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2012-12-11 at 20:54 -0500, Steven Rostedt wrote:
> >
> >> I'm actually thinking that that test should always fail. The
> >> cpupri_find() does a scan of all priorities up to but not including the
> >> current task's priority. If cpupri_find() finds a mask, it means that it
> >> found CPUs that are running only tasks of lower priority than the task
> >> we are checking. Which means, it should never include the task's CPU, as
> >> that CPU should have a higher priority than what is being returned by
> >> lowest_mask. If it can't find a set of CPUs of lower priority, it should
> >> return false, and the find_lowest_rq() should exit.
> >>
> >> I'll add a WARN_ON_ONCE() there, and see if I can trigger it. :-/
> >
> > Ah, for select_task_rq_rt() it can get that CPU, because it's called in
> > the wakeup path before the task is added into the CPUs priority. And we
> > definitely want the current CPU in that case.
> >
> Hm ... the latency of the woken task increases iff we overload its
> runqueue, no?
> 

No, it doesn't.

-- Steve

