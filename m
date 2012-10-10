Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2JJAWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:22:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2JJAWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:22:00 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=GpMzQMeox_P3rUvCrUMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349828517.24256.47.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 09 Oct 2012 20:21:57 -0400
In-Reply-To: <1349806792.24256.34.camel@gandalf.local.home>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>
	 <1349806792.24256.34.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2012-10-09 at 14:19 -0400, Steven Rostedt wrote:

I applied and tested the backported patches to 3.4-rt. Things look good
and will be posting the -rc1 soon.

Status for 3.0-rt:


> 0000-scsi-qla2xxx-fix-bug-sleeping-function-called-from-invalid-context.patch
> 0001-upstream-net-rt-remove-preemption-disabling-in-netisched-better-debug-output-for-might-sleep.patch f_rx.patch

The above two have been applied to both 3.0-rt and 3.4-rt previously.

> 0002-random-make-it-work-on-rt.patch

The above has been applied to 3.4-rt but is not applicable to 3.0-rt, as
the add_interrupt_randomness() does not exist.

> 0003-softirq-init-softirq-local-lock-after-per-cpu-section-is-set-up.patch

For 3.0-rt the softirq_early_init() comes after the printk banner, which
is after per cpu data has been set up. But for consistency, I made this
patch moved to before the banner in the same location as 3.4-rt+ is.


> 0004-mm-slab-fix-potential-deadlock.patch
> 0005-mm-page-alloc-use-local-lock-on-target-cpu.patch
> 0006-rt-rw-lockdep-annotations.patch

The above applied to 3.0-rt with no issues.

* sched-better-debug-output-for-might-sleep.patch 

Had slight conflicts, but trivial fix.

> 0007-stomp-machine-deal-clever-with-stopper-lock.patch

With this one, things have changed quite a bit. I'll take a deeper look
at what you did and figure out how this applies to v3.0-rt.

-- Steve



