Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0JYKNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:13:12 -0400
Received: from canuck.infradead.org ([134.117.69.58]:42318 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab0JYKNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:13:11 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1287788622-25860-1-git-send-email-venki@google.com>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
	 <1287788622-25860-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Oct 2010 12:12:53 +0200
Message-ID: <1288001573.15336.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 16:03 -0700, Venkatesh Pallipadi wrote:
> I started making small changes to the code, but none of the change helped much.
> I think the problem with the current code is that, even though idle CPUs
> update load, the fold only happens when one of the CPU is busy
> and we end up taking its load into global load.
> 
> So, I tried to simplify things and doing the updates directly from idle loop.
> This is only a test patch, and eventually we need to hook it off somewhere
> else, instead of idle loop and also this is expected work only as x86_64
> right now.
> 
> Peter: Do you think something like this will work? loadavg went
> quite on two of my test systems after this change (4 cpu and 24 cpu).

Not really, CPUs can stay idle for _very_ long times (!x86 cpus that
don't have crappy timers like HPET which roll around every 2-4 seconds).

But all CPUs staying idle for a long time is exactly the scenario you
fix before using the decay_load_misses() stuff, except that is for the
load-balancer per-cpu load numbers not the global cpu load avg. Won't a
similar approach work here?
