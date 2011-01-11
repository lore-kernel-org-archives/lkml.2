Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1AKRYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:24:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59439 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab1AKRYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:24:13 -0500
Subject: Re: [PATCH] clocks_calc_mult_shift(): rename minsec argument
 according to actual usage
From: john stultz <johnstul@us.ibm.com>
To: Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1101111207140.17086@xanadu.home>
References: <alpine.LFD.2.00.1101111207140.17086@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 09:24:04 -0800
Message-ID: <1294766644.3441.9.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 12:18 -0500, Nicolas Pitre wrote:
> The minsec argument to clocks_calc_mult_shift() is misnamed. It is used 
> to clamp the magnitude of the mult factor so that a multiplication with 
> any value in the given range won't overflow a 64 bit result.  Let's 
> rename it to match the actual usage.
> 
> Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Acked-by: John Stultz <johnstul@us.ibm.com>

Thomas, mind picking this up for 2.6.38?

thanks
-john

> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c18d7ef..8588abc 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -113,7 +113,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
>   * @shift:	pointer to shift variable
>   * @from:	frequency to convert from
>   * @to:		frequency to convert to
> - * @minsec:	guaranteed runtime conversion range in seconds
> + * @maxsec:	guaranteed runtime conversion range in seconds
>   *
>   * The function evaluates the shift/mult pair for the scaled math
>   * operations of clocksources and clockevents.
> @@ -122,7 +122,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
>   * NSEC_PER_SEC == 1GHz and @from is the counter frequency. For clock
>   * event @to is the counter frequency and @from is NSEC_PER_SEC.
>   *
> - * The @minsec conversion range argument controls the time frame in
> + * The @maxsec conversion range argument controls the time frame in
>   * seconds which must be covered by the runtime conversion with the
>   * calculated mult and shift factors. This guarantees that no 64bit
>   * overflow happens when the input value of the conversion is
> @@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
>   * factors.
>   */
>  void
> -clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
> +clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
>  {
>  	u64 tmp;
>  	u32 sft, sftacc= 32;
> @@ -140,7 +140,7 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
>  	 * Calculate the shift factor which is limiting the conversion
>  	 * range:
>  	 */
> -	tmp = ((u64)minsec * from) >> 32;
> +	tmp = ((u64)maxsec * from) >> 32;
>  	while (tmp) {
>  		tmp >>=1;
>  		sftacc--;


