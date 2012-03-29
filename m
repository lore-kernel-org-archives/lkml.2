Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2C2Kmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:42:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:51228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2C2Km2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:42:28 -0400
Date: Thu, 29 Mar 2012 12:42:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Hocko <mhocko@suse.cz>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] fix idle ticks in cpu summary line of /proc/stat
In-Reply-To: <20120313080748.GA7754@tiehlicka.suse.cz>
Message-ID: <alpine.LFD.2.02.1203291241360.2542@ionos>
References: <20120311182621.41674b39@de.ibm.com> <20120312121726.GA23608@tiehlicka.suse.cz> <20120312101739.26eb373e@de.ibm.com> <4F5E0CC1.6010102@linux.vnet.ibm.com> <20120312153906.GE3994@tiehlicka.suse.cz> <20120312164145.5110ed5c@de.ibm.com>
 <20120313080748.GA7754@tiehlicka.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Michal Hocko wrote:

> OK, so the updated version of the patch looks like this. I am sorry but
> I had time to only compile test this...
> ---
> >From d12247f14c5f8b00ae97a87442f62e49227a759b Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 12 Mar 2012 13:11:38 +0100
> Subject: [PATCH] nohz: fix idle ticks in cpu summary line of /proc/stat
> 
> Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update
> conditional" introduced a bug in regard to cpu hotplug. The effect is
> that the number of idle ticks in the cpu summary line in /proc/stat is
> still counting ticks for offline cpus.
> 
> Reproduction is easy, just start a workload that keeps all cpus busy,
> switch off one or more cpus and then watch the idle field in top.
> On a dual-core with one cpu 100% busy and one offline cpu you will get
> something like this:
> 
> %Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> 
> The problem is that an offline cpu still has ts->idle_active == 1.
> To fix this we should make sure that the cpu is online when calling
> get_cpu_idle_time_us and get_cpu_iowait_time_us.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Martin, does that solve the problem for you ?

Thanks,

	tglx
