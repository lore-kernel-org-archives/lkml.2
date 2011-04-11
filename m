Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1DKPwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:52:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61394 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1DKPwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:52:14 -0400
Date: Mon, 11 Apr 2011 08:52:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: linux-next: Tree for April 11 (staging/olpc_dcon)
Message-Id: <20110411085200.b2f22e34.randy.dunlap@oracle.com>
In-Reply-To: <20110411135049.148ef002.sfr@canb.auug.org.au>
References: <20110411135049.148ef002.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA323A5.00C9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 13:50:49 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110408:


olpc_dcon.c:(.text+0x11588b): undefined reference to `backlight_device_register'

Hmph.  I thought that adding
	depends on BACKLIGHT_CLASS_DEVICE
would be sufficient, but noooooo, that spews:

drivers/i2c/Kconfig:5:error: recursive dependency detected!
drivers/i2c/Kconfig:5:	symbol I2C is selected by FB_OLPC_DCON
drivers/staging/olpc_dcon/Kconfig:1:	symbol FB_OLPC_DCON depends on BACKLIGHT_CLASS_DEVICE
drivers/video/backlight/Kconfig:125:	symbol BACKLIGHT_CLASS_DEVICE is selected by PANEL_SHARP_LS037V7DW01
drivers/video/omap2/displays/Kconfig:18:	symbol PANEL_SHARP_LS037V7DW01 depends on OMAP2_DSS
drivers/video/omap2/dss/Kconfig:1:	symbol OMAP2_DSS is selected by VIDEO_OMAP2_VOUT
drivers/media/video/omap/Kconfig:1:	symbol VIDEO_OMAP2_VOUT depends on VIDEO_CAPTURE_DRIVERS
drivers/media/video/Kconfig:73:	symbol VIDEO_CAPTURE_DRIVERS depends on VIDEO_V4L2
drivers/media/video/Kconfig:5:	symbol VIDEO_V4L2 depends on VIDEO_V4L2_COMMON
drivers/media/Kconfig:51:	symbol VIDEO_V4L2_COMMON depends on I2C


Any other suggestions?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
