Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2CVKcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:32:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:40270 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2CVKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:32:29 -0400
Date: Thu, 22 Mar 2012 11:32:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Gordeev <agordeev@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] genirq: Get rid of unneeded force parameter in
 irq_finalize_oneshot()
In-Reply-To: <20120319145848.GG2147@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LFD.2.02.1203221128260.2542@ionos>
References: <20120319145848.GG2147@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Alexander Gordeev wrote:

> The only place irq_finalize_oneshot() is called with force parameter set
> is the threaded handler error exit path. But IRQTF_RUNTHREAD is dropped
> at this point and irq_wake_thread() is not going to reset it again,
> since PF_EXITING is set for this thread already. So we will drop the
> thread's bit in threads_oneshot anyway and the force parameter is
> superfluous.

Wrong.

CPU 0				CPU 1

    do_exit()
				check(PF_EXITING)
				set_bit(IRQTF_RUNTHREAD)
				...
    set(PF_EXITING)
    exit_irq_thread()

    if (test_bit(IRQTF_RUNTHREAD))
	goto out;

	-> FAIL

Thanks,

	tglx
