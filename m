Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2DRMLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:11:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23655 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2DRMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:11:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Wed, 18 Apr 2012 14:11:10 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
In-reply-to: <20120417174029.GC22406@pengutronix.de>
To: "'Wolfram Sang'" <w.sang@pengutronix.de>,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        kyungmin.park@samsung.com, broonie@opensource.wolfsonmicro.com
Message-id: <00dd01cd1d5c$57ce7f80$076b7e80$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Ac0cwTsiy5bl3Gi8T+2B9watbQcxeQAgvZpA
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-4-git-send-email-k.lewandowsk@samsung.com>
 <20120417174029.GC22406@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Tuesday, April 17, 2012 7:40 PM Wolfram Sang wrote:

> On Wed, Mar 21, 2012 at 08:11:53PM +0100, Karol Lewandowski wrote:
> > This patch adds support for s3c2440 I2C bus controller dedicated HDMIPHY device on
> > Exynos4 platform. Some quirks are introduced due to differences between HDMIPHY
> > and other I2C controllers on Exynos4.  These differences are:
> > - no GPIOs, HDMIPHY is inside the SoC and the controller is connected
> >   internally
> > - due to unknown reason (probably HW bug in HDMIPHY and/or the controller) a
> >   transfer fails to finish. The controller hangs after sending the last byte,
> >   the workaround for this bug is resetting the controller after each transfer
> >
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> > Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  .../devicetree/bindings/i2c/samsung-i2c.txt        |   11 +++++-
> >  drivers/i2c/busses/i2c-s3c2410.c                   |   35 ++++++++++++++++++++
> >  2 files changed, 44 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
> b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
> > index 38832c7..c6670f9 100644
> > --- a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
> > +++ b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
> > @@ -10,14 +10,21 @@ Required properties:
> >      region.
> >    - interrupts: interrupt number to the cpu.
> >    - samsung,i2c-sda-delay: Delay (in ns) applied to data line (SDA) edges.
> > -  - gpios: The order of the gpios should be the following: <SDA, SCL>.
> > -    The gpio specifier depends on the gpio controller.
> >
> >  Optional properties:
> > +  - gpios: The order of the gpios should be the following: <SDA, SCL>.
> > +    The gpio specifier depends on the gpio controller. Required in all cases
> > +    except when "samsung,i2c-no-gpio" is also specified.
> > +  - samsung,i2c-no-gpio: input/output lines of the controller are
> > +    permanently wired to the respective client, there are no gpio
> > +    lines that need to be configured to enable this controller
> 
> Can't we just skip this property...

All standard s3c-24x0 i2c controllers require gpio lines for proper operation,
so lack of the gpios property should be considered as an error. However there
is a special case of internal, embedded i2c controller which has no such gpio 
lines at all.

> >    - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If not
> >      specified, default value is 0.
> >    - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
> >      specified, the default value in Hz is 100000.
> > +  - samsung,i2c-quirk-hdmiphy: Quirk for HDMI PHY block found on
> > +    Exynos4 platform - reduce timeout and reset controller after each
> > +    transfer
> 
> ... and this one, if we declare a new compatible-entry for exynos4?

It is not strictly related to Exynos4 SoCs. Exynos4 SoC has 8 standard s3c2440 style
i2c controllers and one additional, internal controller for HDMIPHY, which needs 
some workarounds in the driver. Maybe the quirk should be named 'broken timeout 
detection'

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


