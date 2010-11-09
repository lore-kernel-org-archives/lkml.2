Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab0KIMr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:47:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0KIMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:47:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Tue, 9 Nov 2010 13:47:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <201011080756.50930.arnd@arndb.de> <20101109102641.GB2690@riccoc20.at.omicron.at>
In-Reply-To: <20101109102641.GB2690@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091347.00310.arnd@arndb.de>
X-Provags-ID: V02:K0:3SO2a6Za3eirzZ9tTxbt1tr2s/3kaPoP5wEOw1VQV8W
 +9c2ymGt/1KOfLn7zJo1Lqr4mw9rj/NiLwcPrxZKGIyYAwA58H
 UkJPmaD0TA9fBYKkMVR2XrTaXvo6GuyCpeC1ISzs2DDlOYgf9r
 iURoXJO+EA8kZmL/oWzuIln/3Y8CrAmUbgAklfOzvp63K27zoA
 AW4uKac8Q++fCAUTemN9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 November 2010, Richard Cochran wrote:
> On Mon, Nov 08, 2010 at 07:56:50AM +0100, Arnd Bergmann wrote:
> > On Thursday 04 November 2010, Richard Cochran wrote:
> > >  #define CPUCLOCK_PERTHREAD_MASK	4
> > >  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
> > >  #define CPUCLOCK_CLOCK_MASK	3
> > > @@ -28,12 +40,17 @@ struct cpu_timer_list {
> > >  #define CPUCLOCK_VIRT		1
> > >  #define CPUCLOCK_SCHED		2
> > >  #define CPUCLOCK_MAX		3
> > > +#define CLOCKFD			CPUCLOCK_MAX
> > > +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
> > 
> > It looks like you are turning a kernel internal interface into a user ABI,
> > which I think is highly questionable. Using the bits like this internally is
> > ok, but making it part of the syscall ABI means that we can never change this
> > in the future.
> 
> This set of defines is already part of the ABI and has been copied
> into glibc.  I am extending the (mis)use of the clock id by adding one
> more case.

Ok, that is very different then. I wonder why posix-timers.h is not an exported
header file, it might be good to change that to make it explicit which parts of
it define the ABI and which parts are kernel internal.

	Arnd
