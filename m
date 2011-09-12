Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab1ILOcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:32:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab1ILOce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:32:34 -0400
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 12 Sep 2011 16:32:10 +0200
In-Reply-To: <4E6E1693.7080606@redhat.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
	 <1315836358.26517.43.camel@twins> <4E6E1693.7080606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315837930.26517.49.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 17:26 +0300, Avi Kivity wrote:
> On 09/12/2011 05:05 PM, Peter Zijlstra wrote:
> > Subject: llist: Remove cpu_relax() usage in cmpxchg loops
> > From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> > Date: Mon Sep 12 15:50:49 CEST 2011
> >
> > Initial benchmarks show they're a net loss (2 socket wsm):
> >
> >   $ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance>  $i; done
> >   $ echo 4096 32000 64 128>  /proc/sys/kernel/sem
> >   $ ./sembench -t 2048 -w 1900 -o 0
> >
> 
> We hyperthreading enabled, and were all threads loaded?  cpu_relax 
> allows the other thread to make more progress while the spinner relaxes.

Yeah, with HT enabled, the benchmark runs 2048 tasks and does 1900 task
bulk wakeups or so. Forgot the details, but it basically stresses the
sleep+wakeup paths like nobodies business.


