Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2BOOQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:16:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:53443 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab2BOOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:16:36 -0500
Date: Wed, 15 Feb 2012 15:16:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20111108191149.GA7236@sgi.com>
Message-ID: <alpine.LFD.2.02.1202151512420.2794@ionos>
References: <20111108191149.GA7236@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Dimitri Sivanich wrote:
> 
> Allow manual override of the tick_do_timer_cpu.
> 
> While not necessarily harmful, doing jiffies updates on an application cpu
> does cause some extra overhead that HPC benchmarking people notice.  They
> prefer to have OS activity isolated to certain cpus.  They like reproducibility
> of results, and having jiffies updates bouncing around introduces variability.

I really wonder about this changelog. The only case where jiffies
updates bounces around is the NOHZ case. In all other modes (periodic
or highres) the boot cpu gets the do_timer() duty and it's never
assigned to any other cpu.

So what's the point of this exercise? Moving it away from CPU0 for
acedemic reasons or what?

Thanks,

	tglx

 
