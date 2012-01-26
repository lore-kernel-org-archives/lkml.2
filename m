Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2AZTZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:25:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2AZTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:25:11 -0500
Date: Thu, 26 Jan 2012 17:24:55 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20120126192455.GE9128@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
 <20120126111648.GH3853@elte.hu>
 <20120126122200.GA9128@infradead.org>
 <20120126130919.GA20115@elte.hu>
 <20120126143037.GD9128@infradead.org>
 <20120126183223.GB8630@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126183223.GB8630@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 26, 2012 at 07:32:23PM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > > > ptrace_may_access(task, PTRACE_MODE_READ) fails for some 
> > > > tasks owned by the user because, IIRC, in 
> > > > __ptrace_may_access:
> > 
> > > Which tasks are these, are they privileged in any sense?
> > 
> > IIRC one of them was a child of sshd, that runs as root and 
> > then changes the child ownership to the user logging in.
> 
> It's probably privileged then - or at least not sufficiently 
> deprivileged.
> 
> Skipping them ought to be the right solution - it's not like 
> such tasks tend to create a lot of overhead worth profiling. 
> They are also not debuggable via gdb so they are not part of the 
> user's development session and such.

Least convoluted way seems to be just to try to call sys_perf_event_open
on then when building the thread list in thread_new__by_uid(), will try
that after soccer :-)

/me vanishes

- Arnaldo

> > I'll continue investigation but probably for now the first 
> > thing to do is to just remove them from the thread_map when 
> > they return -EPERM.
> 
> Yeah. Maybe warn about them in verbose mode or such.
