Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab1BQR6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:58:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1BQR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:58:51 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Lz24SWtJyWAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=6Z8l9LJwAj-ttX9ELcsA:9 a=ykYFAwbwjTH7lnZJAWfpYh2_jwYA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/core] tracing: Add unstable sched clock note to the
 warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110217171823.GB17058@elte.hu>
References: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
	 <tip-5e38ca8f3ea423442eaafe1b7e206084aa38120a@git.kernel.org>
	 <1297957180.23343.915.camel@gandalf.stny.rr.com>
	 <20110217171823.GB17058@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 12:58:49 -0500
Message-ID: <1297965529.23343.922.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 18:18 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 2011-02-17 at 15:00 +0000, tip-bot for Jiri Olsa wrote:
> > > Commit-ID:  5e38ca8f3ea423442eaafe1b7e206084aa38120a
> > > Gitweb:     http://git.kernel.org/tip/5e38ca8f3ea423442eaafe1b7e206084aa38120a
> > > Author:     Jiri Olsa <jolsa@redhat.com>
> > > AuthorDate: Wed, 2 Feb 2011 13:28:18 +0100
> > > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > > CommitDate: Tue, 8 Feb 2011 11:57:22 -0500
> > > 
> > > tracing: Add unstable sched clock note to the warning
> > > 
> > > The warning "Delta way too big" warning might appear on a system with
> > > unstable shed clock right after the system is resumed and tracing
> > > was enabled during the suspend.
> > > 
> > > Since it's not realy bug, and the unstable sched clock is working
> > > fast and reliable otherwise, Steven suggested to keep using the
> > > sched clock in any case and just to make note in the warning itself.
> > > 
> > 
> > 
> > Peter Zijlstra just informed me on IRC that the commit:
> > 
> > cd7240c0b900eb6d690ccee088a6c9b46dae815a
> > x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep
> > states
> > 
> > Prevents the clock from going backwards triggering the warn on. If this
> > is the case, I think we can revert this patch.
> > 
> > I'll wait on the original reporters of the bug to find out. If the clock
> > does not go backwards when the above commit is applied, then this patch
> > is not needed.
> > 
> > If this is the case, do you want me to rebase without it, or should we
> > just revert it?
> 
> A revert would be nicer (with an explanation in it), as i've already pushed out the 
> perc/core tree.
> 
> If you do the revert today against the current perf/core tip (bee96907383e) then i 
> can pull it in a fast-forward way and we'd minimalize the window.

I've just been informed that even with this patch, the clock still goes
backwards after resume.

-- Steve


