Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0GGCkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:40:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920Ab0GGCkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:40:40 -0400
Date: Tue, 6 Jul 2010 19:40:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc3: Load average climbing to 3+ with no apparent
 reason: CPU 98% idle, with hardly no I/O
Message-Id: <20100706194017.a543dfb9.akpm@linux-foundation.org>
In-Reply-To: <20100701104022.404410d6@debian>
References: <20100701104022.404410d6@debian>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 10:40:22 +0300 T__r__k Edwin <edwintorok@gmail.com> wrote:

> Hi,
> 
> I just noticed that my load average is 2.99 and climbing (it is 3.11
> right now).
> CPU is 98% idle, with hardly any I/O at all so I don't know what is
> causing this:
>  10:32:55 up  1:01,  5 users,  load average: 3.28, 3.31, 3.09
> 
> $ vmstat 5
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  0  0      0 492412 490320 1716264    0    0   122    79  331  419  2  1 93  4
>  0  0      0 492388 490320 1716264    0    0     0    13  755  983  0  1 99  0
>  0  0      0 492632 490324 1716040    0    0     1    71 1013 1455  1  1 98  0
>  1  0      0 492132 490340 1716264    0    0     4  1651  947 1223  2  1 96  1
>  0  0      0 491972 490340 1716272    0    0     0    69 1122 1586  2  2 96  0
>  0  0      0 491788 490340 1716272    0    0     0    41 1527 2517  3  2 95  0
>  0  0      0 491884 490340 1716272    0    0     0   107 1419 2193  2
>  1 97  0
> 
> This happens with 2.6.35-rc3-00001-g6bdebf9 (where the -00001 patch is
> this bugfix required for networking to work at all: "net: fix deliver_no_wcard regression on loopback device")
> 
> I have attached the output of cfs-debug-info.sh: cfs-debug-info-2010.07.01-10.29.57.gz
> 
> I don't see anything special in dmesg, just the continous reset of ata9 (CDROM) that I reported about already:
> http://lkml.org/lkml/2010/6/27/83
> Could this cause load average calculation to go wrong?

Could be.  Run `ps aux' and see which tasks are stuck in "D" state (if
any).  Use sysrq-W or `echo w > /proc/sysrq-trigger' (do `dmesg -n 8'
first) to get stack traces of any stuck tasks.  Try to prevent email
client wordwrapping when sending that info out, please.

Robert thinks that your hardware might be busted.  Did you investigate
that further?  Have you rechecked earlier kernel versions to see if
they work OK?

