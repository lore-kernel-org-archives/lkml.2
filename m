Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2CHL00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:26:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37080 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2CHL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:26:25 -0500
MIME-Version: 1.0
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
References: <CAOMZO5DnP7+zupy9vwBPS0+2XtKM1+nLbwCqBzuCqEG5OWbZRQ@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
Date: Thu, 8 Mar 2012 08:26:24 -0300
Message-ID: <CAOMZO5Amo0XFf+TV7PprCL079C5Y0qKmo+k-FfShU7k4SG7W6Q@mail.gmail.com>
Subject: Re: I.MX35 PDK
From: Fabio Estevam <festevam@gmail.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/12, Alex Gershgorin <alexg@meprolight.com> wrote:
...
> Yes this I2C problem, all I2C slave device need response to Host CPU by
> pulls I2C data bus to low, in other words generate ACK, the clock pulse for
> the acknowledge bit is always created by the bus master.
>
> In this case, the camera tries to reset the data bus and generate an ACK,
> but the voltage drops to the area of two volts, although it should be reset
> to zero.
> I replaced R172 with 10K on CPU board and got a good result, but there are
> other surprises

Ok, good.

Can you try to change the I2C1 pad settings in software, so that the
board can work with the original resistor?

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

This is something that needs to be solved, but it does not prevent the
camera to work though.

On my mx31pdk I get the same dmaengine errors and the ov2640 does work fine.

I think you can go ahead and try to use the camera on the mx35pdk now.

You can try:

gst-launch -v v4l2src device=/dev/video0 !
video/x-raw-yuv,width=320,height=240,framerate=25/1 ! ffmpegcolorspace
! fbdevsink

Regards,

Fabio Estevam
