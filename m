Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1AMRES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:04:18 -0500
Received: from www.tglx.de ([62.245.132.106]:43086 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab1AMREO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:04:14 -0500
Date: Thu, 13 Jan 2011 18:03:24 +0100 (CET)
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
In-Reply-To: <90b2beef441615d01c93fcad029c44af4e505c5f.1294917348.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6>
References: <cover.1294917347.git.richard.cochran@omicron.at> <90b2beef441615d01c93fcad029c44af4e505c5f.1294917348.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Richard Cochran wrote:
>  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
>  int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
> -int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
> +int posix_cpu_clock_set(const clockid_t which_clock, struct timespec *ts);

Shouldn't we change the clock_set function to have *ts const in all places ?

>  static int posix_ktime_get_ts(clockid_t which_clock, struct timespec *tp)
> @@ -279,12 +230,29 @@ static __init int init_posix_timers(void)
>  {
>  	struct k_clock clock_realtime = {
>  		.clock_getres = hrtimer_get_res,
> +		/* defaults: */
> +		.clock_adj	= common_clock_adj,
> +		.clock_get	= common_clock_get,
> +		.clock_set	= common_clock_set,
> +		.nsleep		= common_nsleep,
> +		.nsleep_restart	= common_nsleep_restart,
> +		.timer_create	= common_timer_create,
> +		.timer_del	= common_timer_del,
> +		.timer_get	= common_timer_get,
> +		.timer_set	= common_timer_set,
>  	};
>  	struct k_clock clock_monotonic = {
>  		.clock_getres = hrtimer_get_res,
>  		.clock_get = posix_ktime_get_ts,
>  		.clock_set = do_posix_clock_nosettime,
>  		.clock_adj = do_posix_clock_noadjtime,
> +		/* defaults: */
> +		.nsleep		= common_nsleep,
> +		.nsleep_restart	= common_nsleep_restart,
> +		.timer_create	= common_timer_create,
> +		.timer_del	= common_timer_del,
> +		.timer_get	= common_timer_get,
> +		.timer_set	= common_timer_set,
>  	};
>  	struct k_clock clock_monotonic_raw = {
>  		.clock_getres = hrtimer_get_res,
> @@ -293,6 +261,11 @@ static __init int init_posix_timers(void)
>  		.clock_adj = do_posix_clock_noadjtime,
>  		.timer_create = no_timer_create,
>  		.nsleep = no_nsleep,
> +		/* defaults: */
> +		.nsleep_restart	= common_nsleep_restart,
> +		.timer_del	= common_timer_del,
> +		.timer_get	= common_timer_get,
> +		.timer_set	= common_timer_set,

Hmm, we do not need to set functional entries for clocks which neither
implement timer_create nor nsleep.

Otherwise I really like the outcome. :)

Thanks for your patience !

       tglx
