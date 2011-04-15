Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1DOLMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:12:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab1DOLMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:12:35 -0400
Subject: Re: [tip:perf/core] perf evsel: Fix inverted test for fixing up
 attr.inherit flag
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, efault@gmx.de,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110414170121.GC3229@ghostprotocols.net>
References: <new-submission>
	 <tip-e603dc15072c7fec0ae263597e6dabc3bb4c5c5b@git.kernel.org>
	 <1302357942.9086.1281.camel@twins>
	 <20110411173536.GA29895@ghostprotocols.net>
	 <1302796046.2035.28.camel@laptop>
	 <20110414170121.GC3229@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Apr 2011 13:12:06 +0200
Message-ID: <1302865926.2388.238.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 14:01 -0300, Arnaldo Carvalho de Melo wrote:
> 
> There was another, sillier problem, now seems to work, ack?
> 
> [acme@emilia linux]$ perf stat ~/loop_1b_instructions-4x
> 
>  Performance counter stats for '/home/acme/loop_1b_instructions-4x':
> 
>        1451.781634 task-clock-msecs         #      3.965 CPUs 
>              1,463 context-switches         #      0.001 M/sec
>                  3 CPU-migrations           #      0.000 M/sec
>                187 page-faults              #      0.000 M/sec
>      2,865,021,951 cycles                   #   1973.452 M/sec  (scaled from 70.29%)
>      4,001,127,146 instructions             #      1.397 IPC    (scaled from 80.24%)
>        401,476,915 branches                 #    276.541 M/sec  (scaled from 80.27%)
>             63,800 branch-misses            #      0.016 %      (scaled from 80.29%)
>            262,866 cache-references         #      0.181 M/sec  (scaled from 20.14%)
>             10,938 cache-misses             #      0.008 M/sec  (scaled from 20.07%)
> 
>         0.366184692  seconds time elapsed
> 
> [acme@emilia linux]$
> 
> From 41d8ff6c4be9216cae74dd82381d9f486e82bf22 Mon Sep 17 00:00:00 2001
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Thu, 14 Apr 2011 11:20:14 -0300
> Subject: [PATCH] perf evsel: Fix use of inherit
> 
> perf stat doesn't mmap and its perfectly fine for it to use task-bound
> counters with inheritance.
> 
> So set the attr.inherit on the caller and leave the syscall itself to
> validate it.
> 
> When the mmap fails perf_evlist__mmap will just emit a warning if this
> is the failure reason.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com> 

Yay works!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

