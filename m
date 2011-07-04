Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab1GDRoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:44:34 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48128 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab1GDRod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:44:33 -0400
Date: Mon, 4 Jul 2011 23:14:16 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mundt <lethal@linux-sh.org>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/6] hw_breakpoints: Migrate breakpoint conditional build
 under new config
Message-ID: <20110704174416.GA2166@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
 <1306273947-8410-3-git-send-email-fweisbec@gmail.com>
 <20110704132746.GA2963@in.ibm.com>
 <20110704132912.GB5551@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704132912.GB5551@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 03:29:14PM +0200, Frederic Weisbecker wrote:
> On Mon, Jul 04, 2011 at 06:57:46PM +0530, K.Prasad wrote:
> > On Tue, May 24, 2011 at 11:52:23PM +0200, Frederic Weisbecker wrote:
> > > Migrate conditional hw_breakpoint code compilation under
> > > the new config to prepare for letting the user chose whether
> > > or not to build this feature
> > > 
> > 
> > Making the hardware breakpoint patches modular has always been a goal.
> > I've looked at the PowerPC parts of the code and they look harmless.
> > 
> > Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
> 
> Great!
> 
> I'll push that soon, thanks guys for your acks!

Meanwhile, I was testing hardware breakpoints through perf and found
that monitoring a given address fails when using 'perf record' (returns
-ENOSPC) while 'perf stat' and watchpoint through gdb works fine (see
logs below).

Has this behaviour been reported for other perf counters?

Thanks,
K.Prasad

# tools/perf/perf --version
perf version 3.0.0-rc5
# 
# grep pid_max /proc/kallsyms 
ffffffff81a25010 D pid_max
ffffffff81a25014 D pid_max_min
ffffffff81a25018 D pid_max_max
# 
# uname -a
Linux llm37.in.ibm.com 3.0.0-rc5 #1 SMP Mon Jul 4 22:24:02 IST 2011
x86_64 x86_64 x86_64 GNU/Linux
# 
# tools/perf/perf stat -e mem:0xffffffff81a25010:rw make kernel/futex.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
make[1]: `kernel/futex.o' is up to date.

 Performance counter stats for 'make kernel/futex.o':

               188 mem:0xffffffff81a25010:rw                                   

      10.734957333 seconds time elapsed

# tools/perf/perf record -e
mem:0xffffffff81a25010:rw make kernel/futex.o

  Error: sys_perf_event_open() syscall returned with 28 (No space left
on device).  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

