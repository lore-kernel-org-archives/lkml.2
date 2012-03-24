Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2CYAbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:31:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2CYAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:31:10 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] s5p-tv: Add initial DT-support for HDMIPHY
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: t.stanislaws@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com
In-Reply-To: <4F6C5E74.60104@samsung.com>
References: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com> <1331912532-7798-3-git-send-email-k.lewandowsk@samsung.com> <20120318182458.9CCC43E07BF@localhost> <4F6C5E74.60104@samsung.com>
Date: Sat, 24 Mar 2012 19:03:53 +0000
Message-Id: <20120324190353.8CBE03E0AD3@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 12:28:52 +0100, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> On 18.03.2012 19:24, Grant Likely wrote:
> 
> > On Fri, 16 Mar 2012 16:42:12 +0100, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> >> Make it possible to instantiate driver from device tree description.
> >>
> >> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
> >> ---
> >>  drivers/media/video/s5p-tv/hdmiphy_drv.c |   10 ++++++++++
> >>  1 files changed, 10 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
> >> index 6693f4a..ddf3008 100644
> >> --- a/drivers/media/video/s5p-tv/hdmiphy_drv.c
> >> +++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
> >> @@ -18,6 +18,7 @@
> >>  #include <linux/interrupt.h>
> >>  #include <linux/irq.h>
> >>  #include <linux/err.h>
> >> +#include <linux/of.h>
> >>  
> >>  #include <media/v4l2-subdev.h>
> >>  
> >> @@ -165,10 +166,19 @@ static const struct i2c_device_id hdmiphy_id[] = {
> >>  };
> >>  MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
> >>  
> >> +#ifdef CONFIG_OF
> >> +static struct of_device_id hdmiphy_dt_match[] = {
> >> +	{ .compatible = "samsung,s5pv210-hdmiphy" },
> > 
> > Ditto here; needs to be listed in documentation.
> 
> 
> As these drivers require only irq and io address may add these to
> something like [bindings/arm/samsung/]trivial-devices.txt (like it's
> done for i2c)?

yes.  I just want the values in the documentation where they can be
searched for.

g.
