Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1ALK6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:58:30 -0500
Received: from www.tglx.de ([62.245.132.106]:57253 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1ALK61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:58:27 -0500
Date: Wed, 12 Jan 2011 11:57:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Nick Piggin <npiggin@kernel.dk>,
        Soren Sandmann <ssp@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: BUG: spinlock recursion (sys_chdir, user_path_at, do_path_lookup
 ...)
In-Reply-To: <20110112075229.GZ24920@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1101121153370.12146@localhost6.localdomain6>
References: <20110111110539.GP24920@pengutronix.de> <20110112075229.GZ24920@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1577090938-1294829872=:12146"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1577090938-1294829872=:12146
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jan 2011, Uwe Kleine-König wrote:
> > [   75.280000]  r5:be961ee4 r4:00063015
> > 
> > I started to bisect, but already the first test case showed a different
> > error (my getty dying every few seconds).
> I bisected this one now, the first bad commit is
> 
> 	9c0729d (x86: Eliminate bp argument from the stack tracing routines)
> 
> .  It made a x86 specific change to include/linux/stacktrace.h.

As I said on IRC already, that's complete nonsense. The commit changes
a function prototype which is only relevant for x86. So how should
that affect ARM ?

> According to tglx the lockup above "is related to nicks scalability
> stuff".  I havn't researched yet the offending commit.  Is that
> necessary?

Only if you are interested that the problem gets fixed.

Thanks,

	tglx
---1463795968-1577090938-1294829872=:12146--
