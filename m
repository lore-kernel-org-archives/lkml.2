Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2LSUxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:53:21 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:44151 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2LSUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:53:14 -0500
Date: Wed, 19 Dec 2012 14:53:30 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
Message-ID: <20121219205330.GE1005@beefymiracle.amer.corp.natinst.com>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
 <1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
 <b11edd0b-27ff-48b3-9f2a-1e7ab293cc34@CO9EHSMHS019.ehs.local>
 <50D223DD.8070208@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <50D223DD.8070208@codeaurora.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 02:53:08 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 02:53:08 PM,
	Serialize complete at 12/19/2012 02:53:08 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-19_08:2012-12-19,2012-12-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 12:30:21PM -0800, Stephen Boyd wrote:
> On 12/19/12 11:22, Soren Brinkmann wrote:
[..]
> >
> > A probably unique thing I do is, I set the status of uart0 to disabled. This way
> > I can reuse my rootfs which does not run getty on ttyPS1. And this worked fine
> > before.
> >
> 
> Thanks for testing. It seems that clocks are failing to register. Please
> try this patch.
> 
> --->8-----
> 
> diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
> index 2be22a2..2734715 100644
> --- a/drivers/tty/serial/xilinx_uartps.c
> +++ b/drivers/tty/serial/xilinx_uartps.c
> @@ -948,9 +948,9 @@ static int xuartps_probe(struct platform_device *pdev)
>         struct clk *clk;
> 
>         clk = of_clk_get(pdev->dev.of_node, 0);
> -       if (!clk) {
> -               dev_err(&pdev->dev, "no clock specified\n");
> -               return -ENODEV;
> +       if (IS_ERR(clk)) {
> +               dev_err(&pdev->dev, "failed to get clock\n");
> +               return PTR_ERR(clk);
>         }
> 
>         rc = clk_prepare_enable(clk);

Yes, indeed.

As a side note, this is introduced in my patch "serial: xilinx_uartps:
get clock rate info from dts", which is in xilinx/arm-next (and thus in
linux-next), but as far as I can tell, didn't ever make it into the
arm-soc tree.

Michal, did you have plans for pushing this through arm-soc?

Thanks,

  Josh
