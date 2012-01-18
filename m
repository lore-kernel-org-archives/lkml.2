Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2ARPhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:37:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2ARPhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:37:40 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=p-wZvnPcUTwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=wzB2pxKO4WkMbbDBHxsA:9 a=OS3fNOcJLwR9oDL3KmgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326901057.17534.77.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet
 driver to blame? Yep
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Tim Sander <tim.sander@hbm.com>, Tim Sander <tstone@iss.tu-darmstadt.de>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Date: Wed, 18 Jan 2012 10:37:37 -0500
In-Reply-To: <1326894866.12502.17.camel@marge.simson.net>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <201201171527.19165.tstone@iss.tu-darmstadt.de>
	 <1326822011.7386.40.camel@marge.simson.net>
	 <201201181211.45011.tim.sander@hbm.com>
	 <1326894866.12502.17.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 14:54 +0100, Mike Galbraith wrote:
> On Wed, 2012-01-18 at 12:11 +0100, Tim Sander wrote:
> 
> > > If that's it, you can apply the below, do the same edit, and see which
> > > thread is grinding away.  From there, I'd set a trap.  Let sirq threads
> > > detect that they are being awakened too fast (hey, I can't go to sleep,
> > > the sirq I just processed is busy again, N times in a row) and leave a
> > > note for wakeup_softirqd().  There, WARN_ON(ksoftirqd)[i].help_me) or
> > > such, to see who is flogging which softirq mercilessly.
> > I didn't use this tricks, since top was already doing its job good enough :-).
> 
> Ok, you now know which softirq is being flogged, maybe that's enough for
> someone who knows network goop, dunno.  If you set the trap, you'll get
> an 8x10 color glossy of the slave driver, whip in hand ;-)

This could be another trylock spin loop. I'll have to have a deeper
look.

Thanks,

-- Steve


