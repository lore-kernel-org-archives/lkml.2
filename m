Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2LSEVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:21:53 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:39201
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab2LSEVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:21:45 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432I4015Izz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h906i1155h)
Date: Tue, 18 Dec 2012 20:21:29 -0800
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>, <git@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] arm: zynq: timer: Replace PSS through PS
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
 <ee701193-af05-4e73-9376-42a4c6ac3c01@CO9EHSMHS032.ehs.local>
 <20121219023120.GE27963@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20121219023120.GE27963@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <fa221d49-1a55-4c24-820c-8f7b6995027c@AM1EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tue, Dec 18, 2012 at 08:31:20PM -0600, Josh Cartwright wrote:
> On Tue, Dec 18, 2012 at 04:16:33PM -0800, Soren Brinkmann wrote:
> > The acronym PSS is deprecated by Xilinx. The correct term, which is
> > also used in Xilinx documentation is PS (processing system).
> > This is just a search and replace:
> >  - s/PSS/PS/g
> >  - s/pss/ps/g
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> [..]
> > --- a/arch/arm/mach-zynq/timer.c
> > +++ b/arch/arm/mach-zynq/timer.c
> > @@ -35,17 +35,17 @@
> >   * Timer Register Offset Definitions of Timer 1, Increment base address by 4
> >   * and use same offsets for Timer 2
> >   */
> > -#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
> > -#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
> > -#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
> > -#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
> > -#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
> > -#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
> > -#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
> > -#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
> > -#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
> > -
> > -#define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
> > +#define XTTCPS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
> > +#define XTTCPS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
> > +#define XTTCPS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
> > +#define XTTCPS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
> > +#define XTTCPS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
> > +#define XTTCPS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
> > +#define XTTCPS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
> > +#define XTTCPS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
> > +#define XTTCPS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
> > +
> > +#define XTTCPS_CNT_CNTRL_DISABLE_MASK	0x1
> >  
> >  /* Setup the timers to use pre-scaling, using a fixed value for now that will
> >   * work across most input frequency, but it may need to be more dynamic
> > @@ -57,72 +57,72 @@
> >  #define CNT_CNTRL_RESET		(1<<4)
> >  
> >  /**
> > - * struct xttcpss_timer - This definition defines local timer structure
> > + * struct xttcps_timer - This definition defines local timer structure
> >   *
> >   * @base_addr:	Base address of timer
> >   **/
> > -struct xttcpss_timer {
> > +struct xttcps_timer {
> >  	void __iomem	*base_addr;
> >  };
> >  
> > -struct xttcpss_timer_clocksource {
> > -	struct xttcpss_timer	xttc;
> > +struct xttcps_timer_clocksource {
> > +	struct xttcps_timer	xttc;
> >  	struct clocksource	cs;
> >  };
> >  
> > -#define to_xttcpss_timer_clksrc(x) \
> > -		container_of(x, struct xttcpss_timer_clocksource, cs)
> > +#define to_xttcps_timer_clksrc(x) \
> > +		container_of(x, struct xttcps_timer_clocksource, cs)
> >  
> > -struct xttcpss_timer_clockevent {
> > -	struct xttcpss_timer		xttc;
> > +struct xttcps_timer_clockevent {
> > +	struct xttcps_timer		xttc;
> >  	struct clock_event_device	ce;
> >  	struct clk			*clk;
> >  };
> >  
> > -#define to_xttcpss_timer_clkevent(x) \
> > -		container_of(x, struct xttcpss_timer_clockevent, ce)
> > +#define to_xttcps_timer_clkevent(x) \
> > +		container_of(x, struct xttcps_timer_clockevent, ce)
> >  
> >  /**
> > - * xttcpss_set_interval - Set the timer interval value
> > + * xttcps_set_interval - Set the timer interval value
> >   *
> >   * @timer:	Pointer to the timer instance
> >   * @cycles:	Timer interval ticks
> >   **/
> > -static void xttcpss_set_interval(struct xttcpss_timer *timer,
> > +static void xttcps_set_interval(struct xttcps_timer *timer,
> >  					unsigned long cycles)
> 
> Stylistic nit, but if we're going to be making cosmetic changes of this
> sort, I'd personally like to see the arguments lined up properly:
> 
> static void xttcps_set_interval(struct xttcps_timer *timer,
> 				unsigned long cycles)
I actually don't like that because it's rather high maintenance to align
arguments like this - and keeping them that way. I usually rely on vim with
smartindent set to produce reasonable indent levels.

And reviewing the coding guideline, I'd even say it's not encouraged:
	"Descendants are always substantially shorter than the parent and
	are placed substantially to the right. The same applies to function
	headers with a long argument list."

	Thanks,
	Soren


