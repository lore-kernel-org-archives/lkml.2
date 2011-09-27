Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1I0SVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:21:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:56449 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1I0SVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:21:13 -0400
Date: Tue, 27 Sep 2011 20:21:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark@redhat.com>
Subject: Re: [PATCH][RT] ring-buffer: Convert reader_lock from raw_spin_lock
 into spin_lock
In-Reply-To: <1317146210.26514.33.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1109272020060.2711@ionos>
References: <1317146210.26514.33.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Steven Rostedt wrote:
> +	/*
> +	 * If an NMI die dumps out the content of the ring buffer
> +	 * do not grab locks. We also permanently disable the ring
> +	 * buffer too. A one time deal is all you get from reading
> +	 * the ring buffer from an NMI.
> +	 */
> +	if (!ok_to_lock()) {
> +		if (spin_trylock_irqsave(&cpu_buffer->reader_lock, *flags))
> +			return 1;
> +		printk("Dumping ring buffer from unsafe context\n");
> +		printk("Disabling new ring buffer writes\n");

And what exaclty is the point of these printks/ Aside of that they are
missing KERN_WTF before the string.

Thanks,

	tglx
