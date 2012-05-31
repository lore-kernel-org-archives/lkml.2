Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2EaQl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:41:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:57137 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab2EaQl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:41:56 -0400
Date: Thu, 31 May 2012 18:41:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Make kstat_incr_irqs_this_cpu() called when an irq is actually
 being handled
In-Reply-To: <CAH3Oq6SHLWvcdVUFsmPvqNedBC_QQhVSxrvCiyAUL3TgPQn3wQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205311834270.3231@ionos>
References: <CAH3Oq6SHLWvcdVUFsmPvqNedBC_QQhVSxrvCiyAUL3TgPQn3wQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Ning Jiang wrote:
> kstat_incr_irqs_this_cpu() is supposed to record the irq number
> that is actually taken by a certain cpu. But it failed to do so
> in its current form.

It exactly counts the number of interrupts which are delivered to and
handled by a CPU. That includes interrupts which are delivered in a
state where the device handler cannot be called. And this is on
purpose. We want to see the real number of interruptions not the
number of calls to a device handler.

> For level irq, if its disabled or no action available, we'll skip
> irq handling. When it is enabled later, the irq will be retriggered
> and kstat_incr_irqs_this_cpu() will be counted twice for this
> single irq.

This counts the number of interrupts arrived at the CPU and therefor
it counts TWO in this situation. The CPU is interrupted twice, not
once.

Thanks,

	tglx


