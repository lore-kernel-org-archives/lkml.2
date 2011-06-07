Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab1FGV4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:56:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:44164 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1FGV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:56:50 -0400
Date: Tue, 7 Jun 2011 23:56:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tstone@vlsi.informatik.tu-darmstadt.de>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Threaded Irqs (was "Changing Kernel thread priorities")
In-Reply-To: <201106072328.46186.tstone@vlsi.informatik.tu-darmstadt.de>
Message-ID: <alpine.LFD.2.02.1106072345580.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.tel ekom.at> <4DEDE232.4090007@unican.es> <alpine.LFD.2.02.1106071041550.11814@ionos> <201106072328.46186.tstone@vlsi.informatik.tu-darmstadt.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Tim Sander wrote:
> Nevertheless are there still scheduling latencies for the usermode
> handler thread which then runs at rt prio 99 for about 1ms. I know
> this is not an preempt-rt kernel but i hoped to get better values out
> of this configuration. 
> 
> So if anybody has an idea how to get better latencies out of a 2.6.39
> kernel, please let me know.

The mainline forced irq thread handling is no guarantee for lower
latencies. We need to disable preemption via local_bh_disable() for
the forced threaded interrupts to satisfy the handler vs. softirq
assumptions. So you might get long lasting preempt disabled regions
due to long running interrupt handlers. Aside of that you still can
get long periods due to code which runs with preemption or interrupts
disabled. The forced threaded option has no way to change that.

It would be interesting to find the root cause for those >1ms
latencies. Tracing is your friend.

Thanks,

	tglx
