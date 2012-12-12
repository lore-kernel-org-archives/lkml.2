Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2LLCqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:46:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2LLCqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:46:15 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cU5zP3iA40MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wzXg5rMBBV8A:10 a=s37wLwxS4G2fx1OE9iEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355280374.17101.325.camel@gandalf.local.home>
Subject: Re: [RFC PATCH] sched: rt: fix selecting runqueue for task to be
 pushed
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Dec 2012 21:46:14 -0500
In-Reply-To: <1355277274.17101.323.camel@gandalf.local.home>
References: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
	 <1355149273.17101.176.camel@gandalf.local.home>
	 <CAJd=RBDprA5ruzY6-uQ3L5eSX3Muk8fSpQZbbmsK0oAGwk0WtQ@mail.gmail.com>
	 <1355277274.17101.323.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 20:54 -0500, Steven Rostedt wrote:

> I'm actually thinking that that test should always fail. The
> cpupri_find() does a scan of all priorities up to but not including the
> current task's priority. If cpupri_find() finds a mask, it means that it
> found CPUs that are running only tasks of lower priority than the task
> we are checking. Which means, it should never include the task's CPU, as
> that CPU should have a higher priority than what is being returned by
> lowest_mask. If it can't find a set of CPUs of lower priority, it should
> return false, and the find_lowest_rq() should exit.
> 
> I'll add a WARN_ON_ONCE() there, and see if I can trigger it. :-/

Ah, for select_task_rq_rt() it can get that CPU, because it's called in
the wakeup path before the task is added into the CPUs priority. And we
definitely want the current CPU in that case.

For pushing, the local CPU should never be returned. I'll check to make
sure that's the case too.

-- Steve


