Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0KKI3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:29:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab0KKI3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:29:02 -0500
Date: Thu, 11 Nov 2010 09:28:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [Questions] How to run 'perf top' on ARM to profile kernel
 functions with modules loaded
Message-ID: <20101111082843.GA32728@elte.hu>
References: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
 <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ming Lei <tom.leiming@gmail.com> wrote:

> 2010/11/11 Ming Lei <tom.leiming@gmail.com>:
> > Hi,
> >
> > 'perf top' can't display any functions when modules are loaded on ARM.
> 
> Sorry, should be can't display any kernel functions when modules are loaded
> on ARM.
> 
> Also, when modules are loaded, 'perf report' can't display functions names,
> follows result of 'perf report':
> 
> root@beagleboard:~# perf report
> # Events: 4K cycles
> #
> # Overhead      Command      Shared Object                  Symbol
> # ........  ...........  .................  ......................
> #
>     97.36%      swapper  [musb_hdrc]        [k]  10466c4
>      2.19%         perf  [musb_hdrc]        [k]  10da070
>      0.09%  ksoftirqd/0  [musb_hdrc]        [k]  10db998
>      0.06%         perf  libc-2.9.so        [.] memchr
>      0.04%         perf  libc-2.9.so        [.]    663c0
>      0.02%         perf  perf               [.]     2e80
>      0.02%         perf  libc-2.9.so        [.] closedir
>      0.02%         perf  libc-2.9.so        [.] __read
>      0.02%  flush-179:0  [musb_hdrc]        [k]  10ff124
>      0.02%         perf  libc-2.9.so        [.] memset
>      0.02%         perf  libc-2.9.so        [.] __memcpy_chk
>      0.02%         perf  perf               [.] event__synthesize_comm
>      0.02%         perf           ffff0fc4  [.] ffff0fc4
>      0.02%         perf  perf               [.] hex2u64
>      0.02%         perf  libc-2.9.so        [.] _IO_vfprintf
>      0.02%         perf  libc-2.9.so        [.] fgets
>      0.02%         perf  libpthread-2.9.so  [.] flockfile
>      0.02%         perf  perf               [.] kallsyms__parse
>      0.02%         perf  libc-2.9.so        [.] _IO_getline_info
> 
> Any suggestions or comments?

Must be some bug in the ELF symbol handling code - we've had many cases of quirks 
and special cases there. Please run 'perf archive' and send the resulting 
perf.data.tar.bz2 to Arnaldo in private mail. (the file will be big)

Thanks,

	Ingo
