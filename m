Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2CHLep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:34:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2CHLeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:34:44 -0500
Date: Thu, 8 Mar 2012 12:34:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alex Gershgorin <alexg@meprolight.com>
cc: "'Fabio Estevam'" <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "'s.hauer@pengutronix.de'" <s.hauer@pengutronix.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: I.MX35 PDK
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1203081225290.29847@axis700.grange>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Z0nUv6hquISiGUXJYimzodFkoPaiX+kBtdqS9/E+PnS
 cU1zAIuBhspfEaCYew02lv1Oo8LZQe0JQ+w7IgM1MaN82OzyzC
 hNOAwQTXoZbhBEBtKvedcM8OLWN73uKDQRDKFCtRyI5HvWktUT
 KQYKjLfIE2q0k/hsz5jGxQ0DHhH62U1Fj+i127hP2lJB0o7dvy
 WBWvMjvh8AZ3Ev+5LIVrIilyHZ6/60tDtunIKjrcCIM+S7u2Ql
 3F5ZkyV134dadZH2ZrOVtvHbr9EXW0gld7FQhCseUFz9rc8mnw
 zy6E6KoKgnoGxh+kEnZ/qXQDe9Pz8seWR5z58SV2M/FqwKPtCL
 VGzBnjNMKtuQ8MwPcSzox8gzjPZdsRBnyNpAHWrL+G5014zjVi
 kR7dtgDsVzBuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex

Why is the cc-list mangled again? Why is the V4L list dropped again? 
What's so difficult about hitting the "reply-to-all" button?

On Thu, 8 Mar 2012, Alex Gershgorin wrote:

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
> 	<<switch (i2c_num) {
> 	<<case 0:
> 		<<mxc_request_iomux(MX35_PIN_I2C1_CLK, MUX_CONFIG_SION);
> 		<<mxc_request_iomux(MX35_PIN_I2C1_DAT, MUX_CONFIG_SION);
> 
> 		<<mxc_iomux_set_pad(MX35_PIN_I2C1_CLK, PAD_CONFIG);
> 		<<mxc_iomux_set_pad(MX35_PIN_I2C1_DAT, PAD_CONFIG);
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

First of all it shows, that you're not using the newest kernel:

http://thread.gmane.org/gmane.linux.ports.sh.devel/11508

Secondly, as Fabio just pointed out, these messages are not fatal, which 
is also the reason, why I changed their priority to "debug"

Please, describe the actual problem, that you're getting (if any) and do 
add the v4l list back to the list of recipients!

Thanks
Guennadi

> dmaengine: failed to get dma1chan4: (-22)
> dmaengine: failed to get dma1chan5: (-22)
> dmaengine: failed to get dma1chan6: (-22)
> dmaengine: failed to get dma1chan7: (-22)
> dmaengine: failed to get dma1chan8: (-22)
> dmaengine: failed to get dma1chan9: (-22)
> dmaengine: failed to get dma1chan10: (-22)
> dmaengine: failed to get dma1chan11: (-22)
> dmaengine: failed to get dma1chan12: (-22)
> dmaengine: failed to get dma1chan13: (-22)
> dmaengine: failed to get dma1chan14: (-22)
> dmaengine: failed to get dma1chan15: (-22)
> dmaengine: failed to get dma1chan16: (-22)
> dmaengine: failed to get dma1chan17: (-22)
> dmaengine: failed to get dma1chan18: (-22)
> dmaengine: failed to get dma1chan19: (-22)
> dmaengine: failed to get dma1chan20: (-22)
> dmaengine: failed to get dma1chan21: (-22)
> dmaengine: failed to get dma1chan22: (-22)
> dmaengine: failed to get dma1chan23: (-22)
> dmaengine: failed to get dma1chan24: (-22)
> dmaengine: failed to get dma1chan25: (-22)
> dmaengine: failed to get dma1chan26: (-22)
> dmaengine: failed to get dma1chan27: (-22)
> dmaengine: failed to get dma1chan28: (-22)
> dmaengine: failed to get dma1chan29: (-22)
> dmaengine: failed to get dma1chan30: (-22):
> 
> 
> What is the problem? 
> Guennadi please help me understand 
> 
> Thanks,
>  
> Alex Gershgorin
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
