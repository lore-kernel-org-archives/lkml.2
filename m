Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2BOUaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:30:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:54933 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2BOUaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:30:22 -0500
Date: Wed, 15 Feb 2012 21:30:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
In-Reply-To: <20120215202221.GA29552@srcf.ucam.org>
Message-ID: <alpine.LFD.2.02.1202152125500.2794@ionos>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com> <alpine.LFD.2.02.1202151537500.2794@ionos> <20120215145225.GA21448@srcf.ucam.org> <alpine.LFD.2.02.1202152059230.2794@ionos> <20120215202221.GA29552@srcf.ucam.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Matthew Garrett wrote:

> On Wed, Feb 15, 2012 at 09:14:30PM +0100, Thomas Gleixner wrote:
> 
> > Just for the extended fun of it: The pre hrtimer implementation in
> > Linux put the task on sleep as well up to the next jiffies boundary,
> > so anything which used sleep(0) on a pre hrtimer kernel was going to
> > sleep. That's also the case today when high resolution timers are
> > disabled (compile or runtime).
> > 
> > So anything which relies on sleep(0) as a fast scheduling point is and
> > has been broken forever.
> 
> Excellent. So the real question is what /should/ sleep(0) do - nothing, 
> schedule or sleep for an arbitrary period of time that could be years?

Well, I don't expect slack to be set to years and I really don't want
to special case sleep(0), because then we might end up discussing
special casing usleep(1) or nanosleep(1ns) as well.

slack gets added to all timers, period.

You can tune the slack for your app if you think that it's necessary,
but I bet that in 99,9% of the cases the programmer does not even know
why the hell he put sleep(0), usleep(1) or nanosleep(1ns) into his
code.

Thanks,

	tglx
