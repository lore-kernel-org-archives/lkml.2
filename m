Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1LEK2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:28:52 -0500
Received: from ozlabs.org ([203.10.76.45]:59035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab1LEK2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:28:51 -0500
Date: Mon, 5 Dec 2011 21:28:22 +1100
From: Anton Blanchard <anton@samba.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com
Subject: Re: [PATCH 2/2] watchdog: Softlockup has regular windows where it
 is not armed
Message-ID: <20111205212822.0eaf65a7@kryten>
In-Reply-To: <20111128214704.GH3084@redhat.com>
References: <20111124145315.5d0c4686@kryten>
	<20111124145441.13d715bb@kryten>
	<20111128214704.GH3084@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Don,

> > There might be a reason for this two stage sync but I haven't been
> > able to find it yet. Perhaps the unsynced versions of cpu_clock()
> > and sched_clock_tick() are not safe to call from all contexts?
> 
> According to commit 8c2238eaaf0f774ca0f8d9daad7a616429bbb7f1 that was
> the case, cpu_clock wasn't NMI-safe.  Now it is, thanks to Peter.

Thanks, that makes sense now.

> I have a couple of concerns about the patch.  I am wondering about the
> overhead of getting the timestamp more often now as opposed to just
> setting a boolean for later.  It makes sense to stamp it at the time
> of the call, don't know what the cost is.

I had a similar concern since we do execute this quite a lot. The
overhead of cpu_clock is quite low on powerpc, but not sure about the
other architectures.

> I am also concern about how this affects suspend/resume and kgdb. I
> cc'd Jason above for kgdb.  I'll have to run some tests locally to
> see what long periods of delay look like.  Oh and virt guests too.
> You don't have any test results from that setup do you?

I haven't tested suspend resume, kgdb or virtual guests yet.

Anton
