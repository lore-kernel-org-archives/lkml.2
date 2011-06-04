Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1FDFGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 01:06:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1FDFGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 01:06:31 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=8qa4WLNxHRAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=nO1EuiE4kpzyw7S0l9kA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove the next highest_prio in RT scheduling
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikzjVd69XRb6psBm1aYSem126YynA@mail.gmail.com>
References: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
	 <1306852804.11899.19.camel@gandalf.stny.rr.com>
	 <BANLkTikzjVd69XRb6psBm1aYSem126YynA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 04 Jun 2011 01:06:28 -0400
Message-ID: <1307163988.31814.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-04 at 12:44 +0800, Hillf Danton wrote:

> Both the next and curr reach same result, or incorrect result, before locking

Not quite. curr could be of higher priority than this rq, but next be of
lower priority. In that case, we still want to skip the rq.

But this patch does simplify things, and I give you credit for that.
I'll have to run some tests to see how much in practice this occurs, and
see if it is worth removing and using your method instead.

-- Steve

> RQ, as the comment says, it is racy. After locking RQ, priority is checked again
> to pull the correct tasks with no running task included. The difference between
> the next and curr before locking RQ is the core of the patch that incorrect
> result could be achieved with no updating the next field.
> 
> thanks
>            Hillf


