Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2AZScz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:32:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab2AZScx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:32:53 -0500
Date: Thu, 26 Jan 2012 19:32:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        David Daney <david.daney@cavium.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Fixing perf top --user shortcoming was: Re: [GIT PULL 0/9]
 perf/core improvements and fixes
Message-ID: <20120126183223.GB8630@elte.hu>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
 <20120126111648.GH3853@elte.hu>
 <20120126122200.GA9128@infradead.org>
 <20120126130919.GA20115@elte.hu>
 <20120126143037.GD9128@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126143037.GD9128@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> > > ptrace_may_access(task, PTRACE_MODE_READ) fails for some 
> > > tasks owned by the user because, IIRC, in 
> > > __ptrace_may_access:
> 
> > Which tasks are these, are they privileged in any sense?
> 
> IIRC one of them was a child of sshd, that runs as root and 
> then changes the child ownership to the user logging in.

It's probably privileged then - or at least not sufficiently 
deprivileged.

Skipping them ought to be the right solution - it's not like 
such tasks tend to create a lot of overhead worth profiling. 
They are also not debuggable via gdb so they are not part of the 
user's development session and such.

> I'll continue investigation but probably for now the first 
> thing to do is to just remove them from the thread_map when 
> they return -EPERM.

Yeah. Maybe warn about them in verbose mode or such.

> > If yes and if most of the 'real' tasks a user have can be 
> > profiled just fine then i think we should just skip the 
> > privileged tasks and not abort the profiling session?
> 
> Yeah, that can be done, while debugging I'll emit a warning 
> with the resulting thread_map of "special tasks" to figure out 
> what makes them special.

Ok, sounds great!

Thanks,

	Ingo
