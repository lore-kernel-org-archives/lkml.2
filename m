Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0JUR1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:27:42 -0400
Received: from mail.digium.com ([216.207.245.2]:41844 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0JUR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:27:41 -0400
Message-ID: <4CC07784.4090805@digium.com>
Date: Thu, 21 Oct 2010 12:25:24 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 0/5] Proper kernel irq time reporting -v0
References: <1287614941-32325-1-git-send-email-venki@google.com>
In-Reply-To: <1287614941-32325-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 05:48 PM, Venkatesh Pallipadi wrote:
> This is part 2 of
> "Proper kernel irq time accounting -v4"
> http://lkml.indiana.edu/hypermail//linux/kernel/1010.0/01175.html
> 
> and applies over those changes.
> 

I applied both sets on top of 2.6.36 and tested on x86 32-bit and 64-bit
machines with some telephony cards that interrupt at a 1000Hz rate.  The
time reported in top matched the expected value as measured with the
function graph tracer.  i.e, if /sys/kernel/debug/tracing/trace
indicated that the interrupt handler was averaging 13us, then top was
reporting 1.3% CPU time.  I changed the smp_affinity and the "hi" time
moved around as I would have expected.  I also scheduled work items on
all the CPUs that just disable interrupt and spin for a selectable
period.  Scheduling 100ms of non-interruptible delay at 1 second
intervals resulted in 10% time in "hi" as expected.

Hopefully I can check it out on a Powermac G3 B&W next week sometime,
but FWIW:

Tested-by: Shaun Ruffell <sruffell@digium.com>
