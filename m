Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0KTKsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 05:48:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:59074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0KTKsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 05:48:08 -0500
Subject: Re: [PATCH 3/5] scheduler: cpuacct: Enable platform hooks to track
 cpuusage for CPU frequencies
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Chan <mike@android.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1290218934-8544-4-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	 <1290218934-8544-4-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 20 Nov 2010 11:48:24 +0100
Message-ID: <1290250104.2118.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 18:08 -0800, John Stultz wrote:
> From: Mike Chan <mike@android.com>
> 
> Introduce new platform callback hooks for cpuacct for tracking CPU frequencies
> 
> Not all platforms / architectures have a set CPU_FREQ_TABLE defined
> for CPU transition speeds. In order to track time spent in at various
> CPU frequencies, we enable platform callbacks from cpuacct for this accounting.
> 
> Architectures that support overclock boosting, or don't have pre-defined
> frequency tables can implement their own bucketing system that makes sense
> given their cpufreq scaling abilities.
> 
> New file:
> cpuacct.cpufreq reports the CPU time (in nanoseconds) spent at each CPU
> frequency.

I utterly detest all such accounting crap.. it adds ABI constraints it
add runtime overhead. etc.. 

Can't you get the same information by using the various perf bits? If
you trace the cpufreq changes you can compute the time spend in each
power state, if you additionally trace the sched_switch you can compute
it for each task.


