Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1AVMnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 07:43:09 -0500
Received: from www.tglx.de ([62.245.132.106]:55648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1AVMnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 07:43:07 -0500
Date: Sat, 22 Jan 2011 13:42:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V9 08/13] posix clocks: cleanup the CLOCK_DISPTACH
 macro
In-Reply-To: <20110122123840.GA30830@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1101221342100.31804@localhost6.localdomain6>
References: <cover.1294917347.git.richard.cochran@omicron.at> <90b2beef441615d01c93fcad029c44af4e505c5f.1294917348.git.richard.cochran@omicron.at> <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6> <20110122123840.GA30830@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Richard Cochran wrote:

> On Thu, Jan 13, 2011 at 06:03:24PM +0100, Thomas Gleixner wrote:
> > On Thu, 13 Jan 2011, Richard Cochran wrote:
> > >  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
> > >  int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
> > > -int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
> > > +int posix_cpu_clock_set(const clockid_t which_clock, struct timespec *ts);
> > 
> > Shouldn't we change the clock_set function to have *ts const in all places ?
> 
> The common_clock_set function calls:
> 
>     do_sys_settimeofday
>         security_settime
>             cap_settime
>     do_settimeofday
> 
> so all their signatures must also change.
> 
> Should I add that into my patch set?

Yes please as a separate patch.

Thanks,

	tglx
