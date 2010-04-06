Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0DFCQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:16:12 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48097 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab0DFCQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:16:03 -0400
Date: Tue, 6 Apr 2010 07:45:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Mike Chan <mike@android.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: cpuacct: Track cpuusage per cpu frequency
Message-ID: <20100406021559.GD3630@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1270496004-9715-1-git-send-email-mike@android.com>
 <w2l6599ad831004051252mbf8c4cedz293540bfc7b2f87a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <w2l6599ad831004051252mbf8c4cedz293540bfc7b2f87a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2010-04-05 12:52:57]:

> On Mon, Apr 5, 2010 at 12:33 PM, Mike Chan <mike@android.com> wrote:
> > New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
> >
> > cpuacct.cpufreq accounts for cpu time per-cpu frequency, time is exported
> > in nano-seconds
> 
> Can you clarify the wording of this (and describe it in the relevant
> Documentation/... file)? It's not clear.
> 
> From the code, it appears that the file reports a breakdown of how
> much CPU time the cgroup has been consuming at each different CPU
> frequency level. If so, then you probably want to reword the
> description to avoid "per-cpu", since that makes it sounds as though
> it's reporting something, well, "per CPU".
> 
> Also, what's the motivation here? If it's for power monitoring
> purposes, might it be simpler to just report a single number, that's
> the integral of the CPU usage by frequency index (i.e. calculated from
> the same information that this patch is already gathering in
> cpuacct_charge()) rather than dumping a whole table on userspace?

As utilization increases, won't the integral quickly overflow? BTW,
Mike have you looked at the scaled accounting infrastructure we have
in taskstats?

-- 
	Three Cheers,
	Balbir
