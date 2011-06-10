Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1FJKT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:19:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:44296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1FJKT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:19:26 -0400
Subject: Re: [PATCH] sched: remove resetting exec_start in
 put_prev_task_rt()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Hillf Danton <dhillf@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307673703.9218.42.camel@gandalf.stny.rr.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	 <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
	 <1307622863.9218.40.camel@gandalf.stny.rr.com>
	 <BANLkTi=Y+0h9bMaT6Z4+MhHf==POMKJNoQ@mail.gmail.com>
	 <1307673703.9218.42.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 12:19:06 +0200
Message-ID: <1307701146.3941.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 22:41 -0400, Steven Rostedt wrote:
> On Fri, 2011-06-10 at 10:38 +0800, Yong Zhang wrote:
> > On Thu, Jun 9, 2011 at 8:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > I disagree. Yes the exec_start is reset there, but I like the fact that
> > > it's 0 when not running.
> > 
> > Actually this depends on how we look at the code:
> > if we set exec_start to 0 explicitly, as you said the code is more direct and
> > readable.
> > if we don't set exec_start to 0, we can save one instruction though
> > it's minor.
> > 
> > I have no strong opinion on either of them :)
> 
> I don't have any real strong opinion on this either, so I'll just let
> Peter decide :)

Yay! So IFF its correct (I didn't check) then sure it saves a whole
store :-), I don't think sched_fair clears exec_start on de-schedule
either.
