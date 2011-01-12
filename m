Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1ALMEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:04:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57836 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab1ALMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:03:58 -0500
Date: Wed, 12 Jan 2011 13:03:49 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Nick Piggin <npiggin@kernel.dk>,
        Soren Sandmann <ssp@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: BUG: spinlock recursion (sys_chdir, user_path_at,
 do_path_lookup ...)
Message-ID: <20110112120349.GH24920@pengutronix.de>
References: <20110111110539.GP24920@pengutronix.de>
 <20110112075229.GZ24920@pengutronix.de>
 <alpine.LFD.2.00.1101121153370.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1101121153370.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 11:57:50AM +0100, Thomas Gleixner wrote:
> On Wed, 12 Jan 2011, Uwe Kleine-König wrote:
> > > [   75.280000]  r5:be961ee4 r4:00063015
> > > 
> > > I started to bisect, but already the first test case showed a different
> > > error (my getty dying every few seconds).
> > I bisected this one now, the first bad commit is
> > 
> > 	9c0729d (x86: Eliminate bp argument from the stack tracing routines)
> > 
> > .  It made a x86 specific change to include/linux/stacktrace.h.
> 
> As I said on IRC already, that's complete nonsense. The commit changes
> a function prototype which is only relevant for x86. So how should
> that affect ARM ?
hmm, the conversion that you probably mean is:

	22:26 < ukleinek> hmm, 9c0729dc8062bed96189bd14ac6d4920f3958743 is the first bad commit
	22:26 < tglx> lol
	22:26  * ukleinek goes to bed
	22:27 < ukleinek> then it can only be about include/linux/stacktrace.h
	22:27  * ukleinek goes to bed anyhow
	22:28 < rostedt> ukleinek: btw, you could do the bisect automated with ktest.pl :-)
	22:30 < tglx> ukleinek: right, a change to include/linux/stacktrace.h which is x86 specific
	22:33 < tglx> makes arm explode
	22:33 < tglx> rotfl

I admit I didn't look what was changed there and I understood your
statement as "the change to include/linux/stacktrace.h was x86 specific
and so broke ARM".

I will look into it again after lunch.

> > According to tglx the lockup above "is related to nicks scalability
> > stuff".  I havn't researched yet the offending commit.  Is that
> > necessary?
> 
> Only if you are interested that the problem gets fixed.
OK, will do.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
