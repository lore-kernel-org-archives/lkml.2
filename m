Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1KJIQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:16:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab1KJIQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:16:50 -0500
Date: Thu, 10 Nov 2011 09:14:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111110081458.GC12768@elte.hu>
References: <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125509.GB1022@elte.hu>
 <20111108163331.GJ24234@thunk.org>
 <20111109082321.GA11473@elte.hu>
 <B14DBEB6-46F3-4A30-9FFF-F085A03F32F4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B14DBEB6-46F3-4A30-9FFF-F085A03F32F4@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Graf <agraf@suse.de> wrote:

> [...]
>
> Outside of the kernel tree, you can do your own decisions. If 
> someone thinks it's a great idea to write device emulation in 
> python (I would love that!), he could go in and implement it 
> without having to worry about Linus possibly rejecting it because 
> it's out of scope for a "Linux kernel testing tool". If you want to 
> create the greatest GUI for virtualization the world has ever seen, 
> you can just do it! Nothing holds you back.

We actually recently added Python bindings to event tracing in perf:

 earth5:~/tip> find tools/perf/ -name '*.py'
 tools/perf/python/twatch.py
 tools/perf/util/setup.py
 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
 tools/perf/scripts/python/syscall-counts.py
 tools/perf/scripts/python/sctop.py
 tools/perf/scripts/python/sched-migration.py
 tools/perf/scripts/python/check-perf-trace.py
 tools/perf/scripts/python/futex-contention.py
 tools/perf/scripts/python/failed-syscalls-by-pid.py
 tools/perf/scripts/python/net_dropmonitor.py
 tools/perf/scripts/python/syscall-counts-by-pid.py
 tools/perf/scripts/python/netdev-times.py

... and Linus did not object (so far ;-) - nor does he IMHO have many 
reasons to object as long as the code is sane and useful. Nor did 
Linus object when perf extended its scope from profiling to tracing, 
system monitoring, etc.

While i don't talk for Linus, the only 'hard boundary' that Linus 
enforces and expects all maintainers to enforce that i'm aware of is 
"don't do crazy crap". Everything else is possible as long as it's 
high quality and reasonable, with a good upside story that is 
relevant to the kernel - you can let your imagination run wild, 
there's no artificial barriers that i'm aware of.

Anyway, i have outlined the rough consequences of a user-space 
project being inside the kernel repo in this post:

  http://lkml.org/lkml/2011/11/10/86

... and they are definitely not trivial and easy to meet.

Thanks,

	Ingo
