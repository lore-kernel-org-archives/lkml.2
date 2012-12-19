Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2LSCbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 21:31:15 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:37710 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2LSCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 21:31:14 -0500
Date: Tue, 18 Dec 2012 20:31:20 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        monstr@monstr.eu, John Linn <john.linn@xilinx.com>, git@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] arm: zynq: timer: Replace PSS through PS
Message-ID: <20121219023120.GE27963@beefymiracle.amer.corp.natinst.com>
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
 <ee701193-af05-4e73-9376-42a4c6ac3c01@CO9EHSMHS032.ehs.local>
MIME-Version: 1.0
In-Reply-To: <ee701193-af05-4e73-9376-42a4c6ac3c01@CO9EHSMHS032.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/18/2012 08:31:03 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/18/2012 08:31:03 PM,
	Serialize complete at 12/18/2012 08:31:03 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-19_01:2012-12-18,2012-12-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:16:33PM -0800, Soren Brinkmann wrote:
> The acronym PSS is deprecated by Xilinx. The correct term, which is
> also used in Xilinx documentation is PS (processing system).
> This is just a search and replace:
>  - s/PSS/PS/g
>  - s/pss/ps/g
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
[..]
> --- a/arch/arm/mach-zynq/timer.c
> +++ b/arch/arm/mach-zynq/timer.c
> @@ -35,17 +35,17 @@
>   * Timer Register Offset Definitions of Timer 1, Increment base address by 4
>   * and use same offsets for Timer 2
>   */
> -#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
> -#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
> -#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
> -#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
> -#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
> -#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
> -#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
> -#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
> -#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
> -
> -#define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
> +#define XTTCPS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
> +#define XTTCPS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
> +#define XTTCPS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
> +#define XTTCPS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
> +#define XTTCPS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
> +#define XTTCPS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
> +#define XTTCPS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
> +#define XTTCPS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
> +#define XTTCPS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
> +
> +#define XTTCPS_CNT_CNTRL_DISABLE_MASK	0x1
>  
>  /* Setup the timers to use pre-scaling, using a fixed value for now that will
>   * work across most input frequency, but it may need to be more dynamic
> @@ -57,72 +57,72 @@
>  #define CNT_CNTRL_RESET		(1<<4)
>  
>  /**
> - * struct xttcpss_timer - This definition defines local timer structure
> + * struct xttcps_timer - This definition defines local timer structure
>   *
>   * @base_addr:	Base address of timer
>   **/
> -struct xttcpss_timer {
> +struct xttcps_timer {
>  	void __iomem	*base_addr;
>  };
>  
> -struct xttcpss_timer_clocksource {
> -	struct xttcpss_timer	xttc;
> +struct xttcps_timer_clocksource {
> +	struct xttcps_timer	xttc;
>  	struct clocksource	cs;
>  };
>  
> -#define to_xttcpss_timer_clksrc(x) \
> -		container_of(x, struct xttcpss_timer_clocksource, cs)
> +#define to_xttcps_timer_clksrc(x) \
> +		container_of(x, struct xttcps_timer_clocksource, cs)
>  
> -struct xttcpss_timer_clockevent {
> -	struct xttcpss_timer		xttc;
> +struct xttcps_timer_clockevent {
> +	struct xttcps_timer		xttc;
>  	struct clock_event_device	ce;
>  	struct clk			*clk;
>  };
>  
> -#define to_xttcpss_timer_clkevent(x) \
> -		container_of(x, struct xttcpss_timer_clockevent, ce)
> +#define to_xttcps_timer_clkevent(x) \
> +		container_of(x, struct xttcps_timer_clockevent, ce)
>  
>  /**
> - * xttcpss_set_interval - Set the timer interval value
> + * xttcps_set_interval - Set the timer interval value
>   *
>   * @timer:	Pointer to the timer instance
>   * @cycles:	Timer interval ticks
>   **/
> -static void xttcpss_set_interval(struct xttcpss_timer *timer,
> +static void xttcps_set_interval(struct xttcps_timer *timer,
>  					unsigned long cycles)

Stylistic nit, but if we're going to be making cosmetic changes of this
sort, I'd personally like to see the arguments lined up properly:

static void xttcps_set_interval(struct xttcps_timer *timer,
				unsigned long cycles)

>  {
[..]
> @@ -136,46 +136,46 @@ static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
>   **/
>  static cycle_t __xttc_clocksource_read(struct clocksource *cs)
>  {
> -	struct xttcpss_timer *timer = &to_xttcpss_timer_clksrc(cs)->xttc;
> +	struct xttcps_timer *timer = &to_xttcps_timer_clksrc(cs)->xttc;
>  
>  	return (cycle_t)__raw_readl(timer->base_addr +
> -				XTTCPSS_COUNT_VAL_OFFSET);
> +				XTTCPS_COUNT_VAL_OFFSET);
>  }
>  
>  /**
> - * xttcpss_set_next_event - Sets the time interval for next event
> + * xttcps_set_next_event - Sets the time interval for next event
>   *
>   * @cycles:	Timer interval ticks
>   * @evt:	Address of clock event instance
>   *
>   * returns: Always 0 - success
>   **/
> -static int xttcpss_set_next_event(unsigned long cycles,
> +static int xttcps_set_next_event(unsigned long cycles,
>  					struct clock_event_device *evt)

Likewise for the other functions:

static int xttcps_set_next_event(unsigned long cycles,
				 struct clock_event_device *evt)

And so on.

   Josh
