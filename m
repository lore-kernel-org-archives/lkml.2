Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1DOUuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:50:17 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:40194 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756763Ab1DOUrz (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:1>);
	Fri, 15 Apr 2011 16:47:55 -0400
Message-Id: <4DA93B93020000230002B633@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 15 Apr 2011 14:47:47 -0600
From: "Joey Lee" <jlee@novell.com>
To: <kristoffer.ericson@gmail.com>
Cc: <jp@df5ea.net>, <devel@driverdev.osuosl.org>, "Joey Lee" <JLee@novell.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: backlight control broken on Sony VGN-P21Z with
 staging/gma500
References: <BANLkTikq34nGQU=1U4uvrSu_mRPf-UjLRg@mail.gmail.com>
 <20110415153046.GA10704@Boggieman>
In-Reply-To: <20110415153046.GA10704@Boggieman>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristoffer,

於 五，2011-04-15 於 17:30 +0200，Kristoffer Ericson 提到：
> On Wed, Apr 13, 2011 at 09:54:45PM +0200, Joost Pjotr Vermeer wrote:
> > Hi,
> > 
> > I tried the new gma500 driver from staging on my Sony VGN-P21Z. It
> > seems to work very nice.
> > 
> > But backlight control does not work. It has worked with a previous
> > version of the staging/gma500 driver. I can solve it by removing the
> > call to acpi_video_register() from psb_driver_load() in psb_drv.c.
> > 
> > Can I try anything to find a more specific cause for this?
> > 
> 
> Got same hardware, and the backlight isnt working properly yet. 
> As the driver is very new and alan is working away at bits and pieces I wouldnt expect to much yet.
> 
> Oh and I assume you already grabbed the psb-bl "error" at bootup:
> [    1.507066] fbcon: psbfb (fb0) is primary device
> [    1.982816] fb0: psbfb frame buffer device
> [    1.982871] psb-bl: invalid backlight type
> [    1.982951]  [<c131e603>] ? psb_backlight_init+0x32/0x185
> [    1.982960]  [<c1320467>] ? psb_driver_load+0x47f/0x4b6
> kristoffer@Boggieman:~$ 
> 
> See what it expects for backlight type at init.
> Btw, if you are lazy then just clone my git repository with latest and greatest for gma500.
> 
> Best wishes
> Kristoffer
> 

Matthew's patch added backlight type: Documentation/ABI/stable/sysfs-class-backlight

Could you Please try the folllowing patch? 


>From 71893f42dfe7fdc1fa81adc5c9ad49079603dcbd Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@novell.com>
Date: Sat, 16 Apr 2011 04:44:12 +0800
Subject: [PATCH] gma500: add backlight type


Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/staging/gma500/psb_bl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 70c17b3..05487de 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -136,6 +136,7 @@ int psb_backlight_init(struct drm_device *dev)
 
 	struct backlight_properties props;
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = BRIGHTNESS_MAX_LEVEL;
 
 	psb_backlight_device = backlight_device_register("psb-bl", NULL,
-- 
1.6.0.2



