Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2ARNyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:54:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48900 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757532Ab2ARNyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:54:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/7xm1UA0H7bnLWEi1zEjjQFH7K/0JlczDy11FIDC
	8dOGaM/RNt9WiW
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet
 driver to blame? Yep
From: Mike Galbraith <efault@gmx.de>
To: Tim Sander <tim.sander@hbm.com>
Cc: Tim Sander <tstone@iss.tu-darmstadt.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
In-Reply-To: <201201181211.45011.tim.sander@hbm.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <201201171527.19165.tstone@iss.tu-darmstadt.de>
	 <1326822011.7386.40.camel@marge.simson.net>
	 <201201181211.45011.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 14:54:26 +0100
Message-ID: <1326894866.12502.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 12:11 +0100, Tim Sander wrote:

> > If that's it, you can apply the below, do the same edit, and see which
> > thread is grinding away.  From there, I'd set a trap.  Let sirq threads
> > detect that they are being awakened too fast (hey, I can't go to sleep,
> > the sirq I just processed is busy again, N times in a row) and leave a
> > note for wakeup_softirqd().  There, WARN_ON(ksoftirqd)[i].help_me) or
> > such, to see who is flogging which softirq mercilessly.
> I didn't use this tricks, since top was already doing its job good enough :-).

Ok, you now know which softirq is being flogged, maybe that's enough for
someone who knows network goop, dunno.  If you set the trap, you'll get
an 8x10 color glossy of the slave driver, whip in hand ;-)

	-Mike

