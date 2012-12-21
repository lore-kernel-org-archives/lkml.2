Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2LUP2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:28:38 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:25760
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab2LUP23 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:28:29 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 11
X-BigFish: VPS11(zzbb2dI98dI9371I148cI542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275dhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: Soren Brinkmann <sorenb@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
Thread-Topic: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
Thread-Index: AQHN3irhYIXeOzwhN0ebrdWq6ectEpgjYsZg
Date: Fri, 21 Dec 2012 15:28:10 +0000
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
 <1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
 <b11edd0b-27ff-48b3-9f2a-1e7ab293cc34@CO9EHSMHS019.ehs.local>
 <50D223DD.8070208@codeaurora.org>
 <20121219205330.GE1005@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121219205330.GE1005@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.120]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <296b6ceb-f248-4add-9b4e-bceddcc1613c@CO1EHSMHS028.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Wednesday, December 19, 2012 9:54 PM
> To: Stephen Boyd; Michal Simek
> Cc: Soren Brinkmann; Mike Turquette; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
> 
> On Wed, Dec 19, 2012 at 12:30:21PM -0800, Stephen Boyd wrote:
> > On 12/19/12 11:22, Soren Brinkmann wrote:
> [..]
> > >
> > > A probably unique thing I do is, I set the status of uart0 to
> > > disabled. This way I can reuse my rootfs which does not run getty on
> > > ttyPS1. And this worked fine before.
> > >
> >
> > Thanks for testing. It seems that clocks are failing to register.
> > Please try this patch.
> >
> > --->8-----
> >
> > diff --git a/drivers/tty/serial/xilinx_uartps.c
> > b/drivers/tty/serial/xilinx_uartps.c
> > index 2be22a2..2734715 100644
> > --- a/drivers/tty/serial/xilinx_uartps.c
> > +++ b/drivers/tty/serial/xilinx_uartps.c
> > @@ -948,9 +948,9 @@ static int xuartps_probe(struct platform_device *pdev)
> >         struct clk *clk;
> >
> >         clk = of_clk_get(pdev->dev.of_node, 0);
> > -       if (!clk) {
> > -               dev_err(&pdev->dev, "no clock specified\n");
> > -               return -ENODEV;
> > +       if (IS_ERR(clk)) {
> > +               dev_err(&pdev->dev, "failed to get clock\n");
> > +               return PTR_ERR(clk);
> >         }
> >
> >         rc = clk_prepare_enable(clk);
> 
> Yes, indeed.
> 
> As a side note, this is introduced in my patch "serial: xilinx_uartps:
> get clock rate info from dts", which is in xilinx/arm-next (and thus in linux-next),
> but as far as I can tell, didn't ever make it into the arm-soc tree.
> 
> Michal, did you have plans for pushing this through arm-soc?

I have had this patch in my devel branch for a while. 
It is in arm-next tree right now and I will provide path to mainline.

Thanks for reminder,
Michal


