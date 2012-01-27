Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2A0HJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:09:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47228 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab2A0HJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:09:16 -0500
Message-ID: <1327648147.2919.29.camel@edumazet-laptop>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Date: Fri, 27 Jan 2012 08:09:07 +0100
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 janvier 2012 à 10:09 +0900, KAMEZAWA Hiroyuki a écrit :
> On Thu, 26 Jan 2012 16:43:42 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
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
> 

Also make it generic maybe, and evaluate kstat_irqs(i) once.

seq_put_u32(struct seq_file *m, u32 val);

Converting an "u32" to its decimal representation should be fast, even
for non zero values. Many other users could benefit from this.



