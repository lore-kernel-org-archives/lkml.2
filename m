Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1IUJGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:06:37 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42061 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1IUJGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:06:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ravi, Deepthy" <deepthy.ravi@ti.com>
Subject: Re: [PATCH 4/5] ispccdc: Configure CCDC_SYN_MODE register for UYVY8_2X8 and YUYV8_2X8 formats
Date: Wed, 21 Sep 2011 11:06:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "david.woodhouse@intel.com" <david.woodhouse@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com> <201109210126.20436.laurent.pinchart@ideasonboard.com> <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D090847@dbde03.ent.ti.com>
In-Reply-To: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D090847@dbde03.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109211106.41677.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Deepthy,

On Wednesday 21 September 2011 07:32:44 Ravi, Deepthy wrote:
> On Wednesday, September 21, 2011 4:56 AM Laurent Pinchart wrote:
> > On Tuesday 20 September 2011 16:56:51 Deepthy Ravi wrote:
> >> Configure INPMOD and PACK8 fileds of CCDC_SYN_MODE
> >> register for UYVY8_2X8 and YUYV8_2X8 formats.
> >> 
> >> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
> >> ---
> >> 
> >>  drivers/media/video/omap3isp/ispccdc.c |   11 ++++++++---
> >>  1 files changed, 8 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> >> b/drivers/media/video/omap3isp/ispccdc.c index 418ba65..1dcf180 100644
> >> --- a/drivers/media/video/omap3isp/ispccdc.c
> >> +++ b/drivers/media/video/omap3isp/ispccdc.c
> >> @@ -985,8 +985,12 @@ static void ccdc_config_sync_if(struct
> >> isp_ccdc_device
> >> *ccdc,
> >> 
> >>       syn_mode &= ~ISPCCDC_SYN_MODE_INPMOD_MASK;
> >>       if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
> >> 
> >> -         format->code == V4L2_MBUS_FMT_UYVY8_2X8)
> >> -             syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
> >> +         format->code == V4L2_MBUS_FMT_UYVY8_2X8){
> >> +             if (pdata && pdata->bt656)
> >> +                     syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
> >> +             else
> >> +                     syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
> >> +     }
> >> 
> >>       else if (format->code == V4L2_MBUS_FMT_YUYV8_1X16 ||
> >>       
> >>                format->code == V4L2_MBUS_FMT_UYVY8_1X16)
> >>               
> >>               syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
> >> 
> >> @@ -1172,7 +1176,8 @@ static void ccdc_configure(struct isp_ccdc_device
> >> *ccdc) syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
> >> 
> >>       /* Use PACK8 mode for 1byte per pixel formats. */
> >> 
> >> -     if (omap3isp_video_format_info(format->code)->width <= 8)
> >> +     if ((omap3isp_video_format_info(format->code)->width <= 8) &&
> >> +                     (omap3isp_video_format_info(format->code)->bpp <=
> >> 8))
> > 
> > I'm not sure to follow you. This will clear the PACK8 bit for the
> > YUYV8_2X8 formats. Those formats are 8 bits wide, shouldn't PACK8 be set
> > to store samples on 8 bits instead of 16 bits ?
> > 
> > Is this patch intended to support YUYV8_2X8 sensors in non BT.656 mode
> > with the bridge enabled ? In that case, what would you think about setting
> > the CCDC input format to YUYV8_1X16 instead ? This would better reflect
> > the reality, as the bridge converts YUYV8_2X8 to YUYV8_1X16, and the CCDC
> > is then fed with YUYV8_1X16.
> 
> Yes this is intended for  YUYV8_2X8 sensors in non BT.656 with 8 to 16 bit
> bridge enabled. So the data has to be stored as 16 bits per sample. Thats
> why PACK8 is cleared . I am not sure about using YUYV8_1X16.

My original idea when I wrote the YV support patches was to implement this use 
case with YUYV8_2X8 at the sensor output and YUYV8_1X16 at the CCDC input. The 
ISP driver could then enable the bridge automatically. I'm not sure if that's 
the best solution though, it might be confusing for the users. What I would 
like to keep, however, is the idea of enabling the bridge automatically.

Sakari, any opinion on this ?

> >>               syn_mode |= ISPCCDC_SYN_MODE_PACK8;
> >>       else
> >>               syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;

-- 
Regards,

Laurent Pinchart
