Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab1EXUZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:25:53 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44070 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab1EXUZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:25:52 -0400
Date: Tue, 24 May 2011 13:25:41 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110524202541.GF19633@outflux.net>
References: <20110516165249.GB10929@elte.hu>
 <1305565422.5456.21.camel@gandalf.stny.rr.com>
 <20110517124212.GB21441@elte.hu>
 <1305637528.5456.723.camel@gandalf.stny.rr.com>
 <20110517131902.GF21441@elte.hu>
 <BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com>
 <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <20110524200815.GD27634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524200815.GD27634@elte.hu>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC trimmed, as recommended]

Hi,

On Tue, May 24, 2011 at 10:08:15PM +0200, Ingo Molnar wrote:
> * Will Drewry <wad@chromium.org> wrote:
> 
> > The change avoids defining a new trace call type or a huge number of internal 
> > changes and hides seccomp.mode=2 from ABI-exposure in prctl, but the attack 
> > surface is non-trivial to verify, and I'm not sure if this ABI change makes 
> > sense. It amounts to:
> > 
> >  include/linux/ftrace_event.h  |    4 +-
> >  include/linux/perf_event.h    |   10 +++++---
> >  kernel/perf_event.c           |   49 +++++++++++++++++++++++++++++++++++++---
> >  kernel/seccomp.c              |    8 ++++++
> >  kernel/trace/trace_syscalls.c |   27 +++++++++++++++++-----
> >  5 files changed, 82 insertions(+), 16 deletions(-)
> > 
> > And can be found here: http://static.dataspill.org/perf_secure/v1/
> 
> Wow, i'm very impressed how few changes you needed to do to support this!
> [...]
> attr.require_secure: this is basically used to *force* the creation of 
> security-controlling filters, right? It seems to me that this could be done via 
> a seccomp ABI extension as well, without adding this to the perf ABI. That 
> seccomp call could check whether the right events are created and move the task 
> to mode 2 only if that prereq is met - or something like that.

I understood the prctl() API that was outlined earlier, but it seems
this is not going to happen now. What would the programming API actually
look like for an application developer using this perf-style method?

-Kees

-- 
Kees Cook
Ubuntu Security Team
