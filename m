Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031Ab2B1Owe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:52:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964980Ab2B1Owd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:52:33 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=GQe9zCMQTfAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=zHUl26Y9TrHd5ecO_v8A:9 a=H5DWtS_jRK40nINXT4sA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330440751.25686.216.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 09:52:31 -0500
In-Reply-To: <20120228144318.GF1694@m.brq.redhat.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20120228132159.GA1694@m.brq.redhat.com>
	 <20120228133712.GL3683@opensource.wolfsonmicro.com>
	 <1330437729.25686.211.camel@gandalf.stny.rr.com>
	 <20120228140335.GM3683@opensource.wolfsonmicro.com>
	 <20120228144318.GF1694@m.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 15:43 +0100, Jiri Olsa wrote:
> On Tue, Feb 28, 2012 at 02:03:35PM +0000, Mark Brown wrote:
> > On Tue, Feb 28, 2012 at 09:02:09AM -0500, Steven Rostedt wrote:
> > > On Tue, 2012-02-28 at 13:37 +0000, Mark Brown wrote:
> > 
> > > > ARM.  If it was not possible to switch off PERF_EVENTS it shouldn't be a
> > > > config option in the code as this is just creating complexity and
> > > > potential breakage.
> > 
> > > It is possible to switch off PERF_EVENTS, just not on x86 :-/
> > 
> > Well, if you insist on using these restricted architectures :P
> 
> reproduced ;) looking for fix..
> 
> jirka
> 
> 
> [jolsa@m tip]$ make   ARCH=arm CROSS_COMPILE=armv5tel-redhat-linux-gnueabi- uImage 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      kernel/trace/trace_export.o
> In file included from kernel/trace/trace_export.c:197:
> kernel/trace/trace_entries.h:58: error: ‘perf_ftrace_event_register’
> undeclared here (not in a function)
> make[2]: *** [kernel/trace/trace_export.o] Error 1
> make[1]: *** [kernel/trace] Error 2
> make: *** [kernel] Error 2

Hmm, I'm surprised my cross build test didn't catch this.

Crap, I think I only ran the defconfig tests, and not the test that also
enables tracing.

I'll update my config to do both automatically.

Thanks!

-- Steve


