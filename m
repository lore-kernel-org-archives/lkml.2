Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1AML00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:26:26 -0500
Received: from www.tglx.de ([62.245.132.106]:34558 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab1AML0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:26:25 -0500
Date: Thu, 13 Jan 2011 12:25:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH
 macro
In-Reply-To: <20110113043037.GA17726@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1101131225040.2678@localhost6.localdomain6>
References: <cover.1293820862.git.richard.cochran@omicron.at> <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at> <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6> <20110113043037.GA17726@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Richard Cochran wrote:
> On Tue, Jan 11, 2011 at 01:57:23PM +0100, Thomas Gleixner wrote:
> > 
> > static clockid_t clock_get_array_id(const clockid_t id)
> > {
> > 	if (id >= 0)
> > 	       return id < MAX_CLOCKS ? id : POSIX_INV_CLOCK_ID;
> > 
> >       	if (clock_is_posix_cpu(id))
> > 		return POSIX_CPU_CLOCK_ID;
> > 
> > 	return POSIX_INV_CLOCK_ID;
> > }
> > 
> > static inline int dispatch_clock_getres(const clockid_t id, struct timespec *ts)
> > {
> > 	struct k_clock *clk = &posix_clocks[clock_get_array_id(id)];
> > 
> > 	return clk->clock_getres ? clk->clock_getres(id, ts) : -EINVAL;
> > }
> 
> I would like to take this idea one step further, like so:
> 
> static struct k_clock *clockid_to_kclock(const clockid_t id)
> {
> 	if (id >= 0)
> 		return id < MAX_CLOCKS ?
> 			&posix_clocks[id] : &posix_clocks[POSIX_INV_CLOCK_ID];
> 	...
> }
> 
> SYSCALL( ... , const clockid_t id, struct timespec *ts)
> {
> 	struct k_clock *clk = clockid_to_kclock(id);
> 
> 	return clk->clock_getres ? clk->clock_getres(id, ts) : -EINVAL;
> }
> 
> What do you think?

Yeah, that's even better!
