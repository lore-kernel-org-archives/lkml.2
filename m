Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab2J0TK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:10:57 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41807 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab2J0TK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:10:56 -0400
Date: Sat, 27 Oct 2012 12:10:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, stable@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PATCH] cpufreq: powernow-k8: Remove bogus smp_processor_id()
 usage
Message-ID: <20121027191051.GA2693@htj.dyndns.org>
References: <alpine.LFD.2.02.1210271927170.2756@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210271927170.2756@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Sat, Oct 27, 2012 at 07:29:25PM +0200, Thomas Gleixner wrote:
> This is fully preemptible non cpu bound context though the comment in the
> code says:
> 
> 	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
> 	 * that we're bound to the current CPU and pol->cpu stays online.
> 
> The core only guarantees that pol->cpu stays online, but it has no way
> to bind the thread and this needs to be fully preemptible context as
> powernowk8_target_fn() calls functions which might sleep.
> 
> So the correct solution is to always go through work_on_cpu().

Yeah, that was stupid.  Rafael already has a patch queued.

  http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=commit;h=e4df1cbcc1f329e53a1fff7450b2229e0addff20

Thanks.

-- 
tejun
