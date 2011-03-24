Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318Ab1CXUy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:54:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933904Ab1CXUyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:54:55 -0400
Date: Thu, 24 Mar 2011 21:54:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110324205422.GB2393@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324173020.GA26761@sgi.com>
 <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300999682.2714.23.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 24 mars 2011 à 21:00 +0100, Ingo Molnar a écrit :
> 
> > One good way to see cache bounces is to run a misses/accesses ratio profile:
> > 
> >    perf top -e cache-misses -e cache-references --count-filter 10
> > 
> 
> Oh well , something must be broken...
> 
> "perf top" is working here, but if I use any "-e ...." argument, it
> fails :
> 
> # perf top -e cache-misses
> 
>   Error: sys_perf_event_open() syscall returned with 2 (No such file or directory).
>   /bin/dmesg may provide additional information.
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> # grep PERF_EVENTS .config
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_EVENTS=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> 
> Nothing in dmesg...
> 
> uname -a
> Linux ed001 2.6.38-08165-g2712750-dirty #517 SMP Thu Mar 24 21:31:00 CET 2011 i686 i686 i386 GNU/Linux

Does it work better if you run it as root?

To easiest way to debug as user is to do:

  echo -1 > /proc/sys/kernel/perf_event_paranoid 

and to put this into /etc/sysctl.conf:

  kernel.perf_event_paranoid = -1

Thanks,

	Ingo
