Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1LGAsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:48:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:34445 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1LGAsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:48:32 -0500
Date: Wed, 7 Dec 2011 01:48:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ido Yariv <ido@wizery.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] genirq: Flush the irq thread on synchronization
In-Reply-To: <20111206232824.GA23893@WorkStation>
Message-ID: <alpine.LFD.2.02.1112070140340.2735@ionos>
References: <1322843052-7166-1-git-send-email-ido@wizery.com> <alpine.LFD.2.02.1112022345300.2735@ionos> <alpine.LFD.2.02.1112052248010.2735@ionos> <20111206232824.GA23893@WorkStation>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Ido Yariv wrote:

> Hi Thomas,
> 
> On Mon, Dec 05, 2011 at 10:55:01PM +0100, Thomas Gleixner wrote:
> > Does the following (untested) patch solve your issues?
> 
> I briefly tested this patch and it appears to also solve the issues I
> mentioned.
> 
> I think both solutions would work. The only drawbacks I see in using
> this patch over the other one are that this patch involves a bit more
> locking in synchronize_irq() and irq_finalize_oneshot() (for non-oneshot
> irqs), and that the oneshot mechanism is used for non-oneshot threads.

I don't care about synchronize_irq() at all. It's a slow path anyway.

The extra burden in irq_finalize_oneshot() is somewhat of a concern,
but that locks should be completely uncontended for real threaded irq
users, so in practice it's a non issue.

It's the only solution which actually solves the thread_active leak,
though I just discovered a very narrow race window between the
test_and_clear_bit and the active increment, which is easy to
fix. I'll send out another version tomorrow

Thanks,

	tglx
