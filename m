Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1E0LKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:10:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1E0LKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:10:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Date: Fri, 27 May 2011 13:10:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org> <201105201623.40990.arnd@arndb.de> <20110527091158.GD30146@S2100-06.ap.freescale.net>
In-Reply-To: <20110527091158.GD30146@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271310.18450.arnd@arndb.de>
X-Provags-ID: V02:K0:8EBIbYc0wRSmgB4nUuAYzciRLa5d77Cq6IxHzHjHxQq
 TcGBgz5j91vctw55bFTOnn1m5vREQJs17PyfEo7acUzz/o9VlC
 AY3lP1cg7YovJgUydCqVxIowzxRUubVc/LJzFO+4KJS6y//qFE
 JvET2vwXZSBfy1Ws/FVnoM9+/aW6K8dPV7DoiPymWz4sIsPxzj
 obffm9YOC1Cc8tOH9IRgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 May 2011, Shawn Guo wrote:
> On Fri, May 20, 2011 at 04:23:40PM +0200, Arnd Bergmann wrote:
> [...]
> > No, this would put all gpio devices below the top-level /sys/devices/platform
> > directory, where they certainly don't belong. Please find a proper
> > place and put them there.
> > 
> To make it clear, which one is the best to have all gpio devices below?
> 
>  * /sys/devices/platform/gpio-mxs
>  * /sys/devices/platform/mxs
>  * /sys/devices/platform/mxs/gpio

I would say the third one is closes to how it should be.

The (sysfs) device tree, like the of device tree, should ideally be
modeled after the high-level block diagram of the machine.

In case of i.MX23, that could look like

/sys/devices/system \
  /ahb
    /apbh
       /gpio0
       /gpio1
       /gpmi
    /usb0
    /apbx
       /i2c
       /uart0
       /pwm
       /spi
          /mmc
          /ethernet
       /usb
       /rtc
       /...


You can argue on whether it makes sense to include the top level, or if you
also want to model the various levels of ahb buses, so there is some freedom
here.

	Arnd
