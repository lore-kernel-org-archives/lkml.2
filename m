Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767Ab1ETOXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:23:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab1ETOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:23:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Date: Fri, 20 May 2011 16:23:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org> <201105201223.00427.arnd@arndb.de> <20110520140316.GA27551@S2100-06.ap.freescale.net>
In-Reply-To: <20110520140316.GA27551@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201623.40990.arnd@arndb.de>
X-Provags-ID: V02:K0:N7y4DcnqFoq6gLGonTAEsbcx8kCq9huCp7lcB8LKXxj
 XUwPh/AzFN+fo4kZTN/DRPmgu9MbgOhMLQY1lz9X4CFh0x/AOF
 Pgi9ZXLigZ2Np4ZdDHC2lZipMm2PsuGwbc3DKNBh+sc08Hxra/
 oFopmAt70DMSI1T9msICj53wQThW4HnKhBNK86XYZ+sh+7ZOdZ
 4JpKb2InexmiGacCjQsEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 16:03:17 Shawn Guo wrote:
> On Fri, May 20, 2011 at 12:23:00PM +0200, Arnd Bergmann wrote:
> > 
> > I know it's tempting to use macros for these, but I think it obscures
> > the code a lot, especially when you use them to concatenate identifier
> > names. Why not just do:
> > 
> The pattern is being widely used in mxc/mxs platform device codes.
> If you are not extremely unhappy about this, I would leave it as it
> is to keep consistency.

I think it's a real pain to do it like this, and we need to start
at some point cleaning up the mess. Why not start now?

> > > +
> > > +	return mxs_add_platform_device("mxs-gpio", data->id,
> > > +					res, ARRAY_SIZE(res), NULL, 0);
> > > +}
> > 
> > mxs_add_platform_device doesn't set the parent pointer correctly, I think you
> > should either fix that or open-code the platform device creation to do it
> > right.
> > 
> I see the following in drivers/base/platform.c, function
> platform_device_add():
> 
>         if (!pdev->dev.parent)
>                 pdev->dev.parent = &platform_bus;
> 
> So we are fine?

No, this would put all gpio devices below the top-level /sys/devices/platform
directory, where they certainly don't belong. Please find a proper
place and put them there.

	Arnd
