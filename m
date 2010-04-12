Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0DLUDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:03:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:37591 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0DLUDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:03:43 -0400
From: Thomas Renninger <trenn@suse.de>
To: Mike Chan <mike@android.com>
Subject: Re: [PATCH] sched: cpuacct: Track cpuusage for CPU frequencies
Date: Mon, 12 Apr 2010 22:03:41 +0200
User-Agent: KMail/1.9.10
Cc: menage@google.com, balbir@linux.vnet.ibm.com, dwalker@fifo99.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1270603319-28907-1-git-send-email-mike@android.com> <201004091147.32505.trenn@suse.de> <k2m8bb80c381004091350oa2dd702bk2e9647453c59d645@mail.gmail.com>
In-Reply-To: <k2m8bb80c381004091350oa2dd702bk2e9647453c59d645@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004122203.42436.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010 10:50:33 pm Mike Chan wrote:
> 2010/4/9 Thomas Renninger <trenn@suse.de>:
> > On Wednesday 07 April 2010 03:21:59 Mike Chan wrote:
> >> New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
> >>
> >> cpuacct.cpufreq reports the CPU time (nanoseconds) spent at each CPU
> >> frequency
> >>
> >> Maximum number of frequencies supported is 32. As future architectures
> >> are added that support more than 32 frequency levels, CPUFREQ_TABLE_MAX
> >> in sched.c needs to be updated.
> >
> > Why is accounting of each frequency needed?
>
> The intent is to track time spent at each cpu frequency to measure
> power consumption. Userspace can figure out the mapping between
> frequency and power consumption. This is also a useful indication of
> what kind of hw performance userspace apps need (does Chrome really
> need 1ghz?).
>
> Paul Menage had suggested an integral earlier in my [RFC] patch. I
> wasn't completely against the idea but it had a few shortcomings that
> I couldn't think of decent solutions for. You would have to either
> pre-define power consumption for the cpu frequences per-arch or board
> file. Or have a way to calculate.
Sounds as if this is for specific CPUs/boards only then.
X86 boosting and PCC driver are hard, possibly impossible to track (in respect 
to real power consumption).

> > pcc-cpufreq driver can do every frequency in a range and supports
> > hundreds of different frequencies, thus it does not depend on
> > CPU_FREQ_TABLE. Would the average frequency be enough to track/account?
> Humm, this is a tricky case we haven't yet run into for ARM. Average
> frequency might not be too useful because power is not linear with
> speed. We could possibly have buckets for speeds (hi/lo).
Your whole concept sounds as if it requires limited amount of frequencies. 
Don't mind for the special case I mentioned.

      Thomas
