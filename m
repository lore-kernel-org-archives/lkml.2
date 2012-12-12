Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2LLLoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:44:03 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54083 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2LLLoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <1355280374.17101.325.camel@gandalf.local.home>
References: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
	<1355149273.17101.176.camel@gandalf.local.home>
	<CAJd=RBDprA5ruzY6-uQ3L5eSX3Muk8fSpQZbbmsK0oAGwk0WtQ@mail.gmail.com>
	<1355277274.17101.323.camel@gandalf.local.home>
	<1355280374.17101.325.camel@gandalf.local.home>
Date: Wed, 12 Dec 2012 19:44:00 +0800
Message-ID: <CAJd=RBBLLtOCwVipcKD3g6xRWgVcfWi1q5m6p4TmwAcgOCh+4Q@mail.gmail.com>
Subject: Re: [RFC PATCH] sched: rt: fix selecting runqueue for task to be pushed
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 10:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-12-11 at 20:54 -0500, Steven Rostedt wrote:
>
>> I'm actually thinking that that test should always fail. The
>> cpupri_find() does a scan of all priorities up to but not including the
>> current task's priority. If cpupri_find() finds a mask, it means that it
>> found CPUs that are running only tasks of lower priority than the task
>> we are checking. Which means, it should never include the task's CPU, as
>> that CPU should have a higher priority than what is being returned by
>> lowest_mask. If it can't find a set of CPUs of lower priority, it should
>> return false, and the find_lowest_rq() should exit.
>>
>> I'll add a WARN_ON_ONCE() there, and see if I can trigger it. :-/
>
> Ah, for select_task_rq_rt() it can get that CPU, because it's called in
> the wakeup path before the task is added into the CPUs priority. And we
> definitely want the current CPU in that case.
>
Hm ... the latency of the woken task increases iff we overload its
runqueue, no?

Hillf
