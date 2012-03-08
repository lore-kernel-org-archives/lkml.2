Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2CHNnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:43:22 -0500
Received: from ftp.meprolight.com ([194.90.149.17]:34518 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752699Ab2CHNnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:43:21 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "'s.hauer@pengutronix.de'" <s.hauer@pengutronix.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 8 Mar 2012 15:43:03 +0200
Subject: RE: I.MX35 PDK
Thread-Topic: I.MX35 PDK
Thread-Index: Acz9H3pOZAVRfbtPSUydCVaA1oeZsQABYluO
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8914@MEP-EXCH.meprolight.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>,<Pine.LNX.4.64.1203081225290.29847@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1203081225290.29847@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

Thanks for you comments...

>>>Hi Alex

>>>Why is the cc-list mangled again? Why is the V4L list dropped again?
>>>What's so difficult about hitting the "reply-to-all" button?

 You are absolutely right, I hope that now the cc-list valid.

> Hi Fabio,
>
> Thanks for you response...
>
> > in spite of this I get from ov2640 driver error
> > Here Linux Kernel boot message:
> >
> > "Linux video capture interface: v2.00
> > soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> > mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> > ov2640 0-0030: Product ID error fb:fb"
> >
> > I cannot understand what the problem is, if someone tested this?
>
> >>Looks like a I2C issue.
>
> >>Check the I2C1 pad settings in the mainline kernel.
>
> >>On FSL kernel we have:
>
> #<<define PAD_CONFIG (PAD_CTL_HYS_SCHMITZ | PAD_CTL_PKE_ENABLE |
> >>PAD_CTL_PUE_PUD | PAD_CTL_ODE_OpenDrain)
>
>       <<switch (i2c_num) {
>       <<case 0:
>               <<mxc_request_iomux(MX35_PIN_I2C1_CLK, MUX_CONFIG_SION);
>               <<mxc_request_iomux(MX35_PIN_I2C1_DAT, MUX_CONFIG_SION);
>
>               <<mxc_iomux_set_pad(MX35_PIN_I2C1_CLK, PAD_CONFIG);
>               <<mxc_iomux_set_pad(MX35_PIN_I2C1_DAT, PAD_CONFIG);
>
> >>Also check if you are getting the proper voltage levels at the I2C1 lines.
>
> Yes this I2C problem, all I2C slave device need response to Host CPU by pulls I2C data bus to low, in other words generate ACK, the clock pulse for the acknowledge bit is always created by the bus master.
>
> In this case, the camera tries to reset the data bus and generate an ACK, but the voltage drops to the area of two volts, although it should be reset to zero.
> I replaced R172 with 10K on CPU board and got a good result, but there are other surprises
>
> Linux video capture interface: v2.00
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> ov2640 0-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
> i2c i2c-0: OV2640 Probed
> mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
> dmaengine: failed to get dma1chan0: (-22)
> dmaengine: failed to get dma1chan1: (-22)
> dmaengine: failed to get dma1chan2: (-22)
> dmaengine: failed to get dma1chan3: (-22)

>>>First of all it shows, that you're not using the newest kernel:

>>>http://thread.gmane.org/gmane.linux.ports.sh.devel/11508

I use Linux version 3.3.0-rc6 it contains the changes.

>>>Secondly, as Fabio just pointed out, these messages are not fatal, which
>>>is also the reason, why I changed their priority to "debug"

Ok

>>>Please, describe the actual problem, that you're getting (if any) and do
>>>add the v4l list back to the list of recipients!

At this stage, for me the problem of this type are actual, for the simple reason that I see it the first time.
Thanks for support and patience :-) 

> What is the problem?
> Guennadi please help me understand
>

Regards, 
Alex Gershgorin
 
