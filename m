Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2A3X7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:59:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55434 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2A3X7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:59:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 31 Jan 2012 08:58:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH] Add num_to_str() for speedup /proc/stat
Message-Id: <20120131085820.cba068d6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120130152051.89024fba.akpm@linux-foundation.org>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
	<20120124161221.032325d1.akpm@linux-foundation.org>
	<1327450945.14373.24.camel@edumazet-laptop>
	<20120124172732.19b3d9f4.akpm@linux-foundation.org>
	<1327469372.14373.31.camel@edumazet-laptop>
	<20120125170416.385ee9fa.akpm@linux-foundation.org>
	<20120126185520.25c8f9b6.kamezawa.hiroyu@jp.fujitsu.com>
	<20120126164342.a496ded0.akpm@linux-foundation.org>
	<20120127100933.5e782a33.kamezawa.hiroyu@jp.fujitsu.com>
	<20120126171800.01c2405c.akpm@linux-foundation.org>
	<20120130141619.a35863e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120130152051.89024fba.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 15:20:51 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 30 Jan 2012 14:16:19 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Mon, 30 Jan 2012 14:15:12 +0900
> > Subject: [PATCH] Add num_to_str() for speedup /proc/stat
> > On my 8cpu box.
> > == Before patch ==
> > [root@bluextal test]# time ./stat_check.py
> > 
> > real    0m0.150s
> > user    0m0.026s
> > sys     0m0.121s
> > 
> > == After patch ==
> > [root@bluextal test]# time ./stat_check.py
> > 
> > real    0m0.055s
> > user    0m0.022s
> > sys     0m0.030s
> > 
> > Maybe it's worth to add this simple function.
> 
> I suppose so - the new infrastructure can be used elsewhere.
> 
> I tried doing the
> 
> 	if (kstst_irqs(j) == 0) {
> 		seq_putc(p, ' ');
> 		seq_putc(p, '0');
> 
> think on top of this and didn't observe any improvement.
> 
> 
> I made some changes - please review.  I'm not sure why you did "char
> tmp[66]"?
> 
Your fix seems fine to me.
I'm sorry I copied tmp[66] from number()..

and yes, 0xffffffffffffffff=18446744073709551615 , tmp[21] will be enough.

I'll prepare patch for /proc/<pid>/stat and see 'ps' and 'top' performance.

Thanks,
-Kame

