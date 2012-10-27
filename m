Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2J0TTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:19:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:38439 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab2J0TTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:19:44 -0400
Date: Sat, 27 Oct 2012 21:19:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, stable@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PATCH] cpufreq: powernow-k8: Remove bogus smp_processor_id()
 usage
In-Reply-To: <20121027191051.GA2693@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1210272118590.2756@ionos>
References: <alpine.LFD.2.02.1210271927170.2756@ionos> <20121027191051.GA2693@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2012, Tejun Heo wrote:

> Hello, Thomas.
> 
> On Sat, Oct 27, 2012 at 07:29:25PM +0200, Thomas Gleixner wrote:
> > This is fully preemptible non cpu bound context though the comment in the
> > code says:
> > 
> > 	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
> > 	 * that we're bound to the current CPU and pol->cpu stays online.
> > 
> > The core only guarantees that pol->cpu stays online, but it has no way
> > to bind the thread and this needs to be fully preemptible context as
> > powernowk8_target_fn() calls functions which might sleep.
> > 
> > So the correct solution is to always go through work_on_cpu().
> 
> Yeah, that was stupid.  Rafael already has a patch queued.
> 
>   http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=commit;h=e4df1cbcc1f329e53a1fff7450b2229e0addff20
> 

Good. So more people noticed :)

      tglx
