Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2B1On0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:43:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab2B1OnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:43:25 -0500
Date: Tue, 28 Feb 2012 15:43:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Message-ID: <20120228144318.GF1694@m.brq.redhat.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120228132159.GA1694@m.brq.redhat.com>
 <20120228133712.GL3683@opensource.wolfsonmicro.com>
 <1330437729.25686.211.camel@gandalf.stny.rr.com>
 <20120228140335.GM3683@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120228140335.GM3683@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 02:03:35PM +0000, Mark Brown wrote:
> On Tue, Feb 28, 2012 at 09:02:09AM -0500, Steven Rostedt wrote:
> > On Tue, 2012-02-28 at 13:37 +0000, Mark Brown wrote:
> 
> > > ARM.  If it was not possible to switch off PERF_EVENTS it shouldn't be a
> > > config option in the code as this is just creating complexity and
> > > potential breakage.
> 
> > It is possible to switch off PERF_EVENTS, just not on x86 :-/
> 
> Well, if you insist on using these restricted architectures :P

reproduced ;) looking for fix..

jirka


[jolsa@m tip]$ make   ARCH=arm CROSS_COMPILE=armv5tel-redhat-linux-gnueabi- uImage 
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      kernel/trace/trace_export.o
In file included from kernel/trace/trace_export.c:197:
kernel/trace/trace_entries.h:58: error: ‘perf_ftrace_event_register’
undeclared here (not in a function)
make[2]: *** [kernel/trace/trace_export.o] Error 1
make[1]: *** [kernel/trace] Error 2
make: *** [kernel] Error 2
