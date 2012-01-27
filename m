Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2A0BSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:18:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2A0BSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:18:01 -0500
Date: Thu, 26 Jan 2012 17:18:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120126171800.01c2405c.akpm@linux-foundation.org>
In-Reply-To: <20120127100933.5e782a33.kamezawa.hiroyu@jp.fujitsu.com>
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
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 10:09:33 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > I expect most of these numbers are zero.  I wonder if we would get
> > useful speedups from
> > 
> > 	for_each_irq_nr(j) {
> > 		/* Apologetic comment goes here */
> > 		if (kstat_irqs(j))
> > 			seq_printf(p, " %u", kstat_irqs(j));
> > 		else
> > 			seq_puts(p, " 0");
> > 	}
> 
> Yes. This is very good optimization and shows much optimization.
> I did this at first try  but did complicated ones because it seems
> not interesting. (This is my bad habit...)
> 
> I'll try again and measure time.

seq_puts() is too slow ;)  I bet seq_putc(p, ' ');seq_putc(p, '0') will
complete in negative time.
