Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1AKRL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:11:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab1AKRLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:11:53 -0500
Date: Tue, 11 Jan 2011 15:11:24 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf top -> annotate broken; bisected to 69aad6f1
Message-ID: <20110111171124.GB11968@ghostprotocols.net>
References: <20110111163520.GA4554@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111163520.GA4554@tugrik.mns.mnsspb.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 11, 2011 at 07:35:20PM +0300, Kirill Smelkov escreveu:
> Hello up there,
> 
> Since 69aad6f1ee69546dea8535ab8f3da9f445d57328 (perf tools: Introduce
> event selectors; Jan 3 2011) annotating a symbol in perf top segfaults:
> 
>     Program received signal SIGSEGV, Segmentation fault.
>     [Switching to Thread 0xb714cb90 (LWP 4662)]
>     event_name (evsel=0x0) at util/parse-events.c:274
>     274             return __event_name(type, config);
>     (gdb) bt
>     #0  event_name (evsel=0x0) at util/parse-events.c:274
>     #1  0x0805f892 in display_thread (arg=0x9422448) at builtin-top.c:359
>     #2  0xb77234c0 in start_thread () from /lib/i686/cmov/libpthread.so.0
>     #3  0xb732b84e in clone () from /lib/i686/cmov/libc.so.6
> 
> 
> It used to work...

Thanks for the report, working on a fix.

- Arnaldo
