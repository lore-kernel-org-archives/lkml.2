Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2L1PLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 10:11:55 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:58706 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2L1PLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 10:11:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121221154832.GM1005@beefymiracle.amer.corp.natinst.com>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
	<1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
	<b11edd0b-27ff-48b3-9f2a-1e7ab293cc34@CO9EHSMHS019.ehs.local>
	<50D223DD.8070208@codeaurora.org>
	<20121219205330.GE1005@beefymiracle.amer.corp.natinst.com>
	<296b6ceb-f248-4add-9b4e-bceddcc1613c@CO1EHSMHS028.ehs.local>
	<20121221154832.GM1005@beefymiracle.amer.corp.natinst.com>
Date: Fri, 28 Dec 2012 16:11:51 +0100
Message-ID: <CAHTX3dLfmJ+UU68ABnmzjKNB0SRQg_6_uw3VHy7x2StW+Kb3XA@mail.gmail.com>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
From: Michal Simek <monstr@monstr.eu>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Soren Brinkmann <sorenb@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/21 Josh Cartwright <josh.cartwright@ni.com>:
> On Fri, Dec 21, 2012 at 03:28:10PM +0000, Michal Simek wrote:
>>
>>
>> > -----Original Message-----
>> > From: Josh Cartwright [mailto:josh.cartwright@ni.com]
>> > Sent: Wednesday, December 19, 2012 9:54 PM
>> > To: Stephen Boyd; Michal Simek
>> > Cc: Soren Brinkmann; Mike Turquette; linux-kernel@vger.kernel.org; linux-arm-
>> > kernel@lists.infradead.org
>> > Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
>> >
>> > On Wed, Dec 19, 2012 at 12:30:21PM -0800, Stephen Boyd wrote:
>> > > On 12/19/12 11:22, Soren Brinkmann wrote:
>> > [..]
>> > > >
>> > > > A probably unique thing I do is, I set the status of uart0 to
>> > > > disabled. This way I can reuse my rootfs which does not run getty on
>> > > > ttyPS1. And this worked fine before.
>> > > >
>> > >
>> > > Thanks for testing. It seems that clocks are failing to register.
>> > > Please try this patch.
>> > >
>> > > --->8-----
>> > >
>> > > diff --git a/drivers/tty/serial/xilinx_uartps.c
>> > > b/drivers/tty/serial/xilinx_uartps.c
>> > > index 2be22a2..2734715 100644
>> > > --- a/drivers/tty/serial/xilinx_uartps.c
>> > > +++ b/drivers/tty/serial/xilinx_uartps.c
>> > > @@ -948,9 +948,9 @@ static int xuartps_probe(struct platform_device *pdev)
>> > >         struct clk *clk;
>> > >
>> > >         clk = of_clk_get(pdev->dev.of_node, 0);
>> > > -       if (!clk) {
>> > > -               dev_err(&pdev->dev, "no clock specified\n");
>> > > -               return -ENODEV;
>> > > +       if (IS_ERR(clk)) {
>> > > +               dev_err(&pdev->dev, "failed to get clock\n");
>> > > +               return PTR_ERR(clk);
>> > >         }
>> > >
>> > >         rc = clk_prepare_enable(clk);
>> >
>> > Yes, indeed.
>> >
>> > As a side note, this is introduced in my patch "serial: xilinx_uartps:
>> > get clock rate info from dts", which is in xilinx/arm-next (and thus in linux-next),
>> > but as far as I can tell, didn't ever make it into the arm-soc tree.
>> >
>> > Michal, did you have plans for pushing this through arm-soc?
>>
>> I have had this patch in my devel branch for a while.
>> It is in arm-next tree right now and I will provide path to mainline.
>
> Will you be rolling in Stephen's suggestions, or should he/I cook up a
> patch on top with the fix in place?

Here is the patch I have applied.

http://git.xilinx.com/?p=linux-xlnx.git;a=commit;h=a3607ea56f4455c515201ab91d2304a634925f6c

> It probably makes sense to pull the quoted fix above directly into the
> patch before it hits mainline, and we can change the use of of_clk_get
> as a patch on top.  Thoughts?

Stephen: Can you please tell me how do you want to add these patches
to mainline?
Through arm-soc tree? Have you asked for pulling?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
