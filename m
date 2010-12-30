Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0L3KDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 05:03:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0L3KDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 05:03:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: (arm-)global platform device registration functions
Date: Thu, 30 Dec 2010 11:03:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20101229162512.GI14221@pengutronix.de>
In-Reply-To: <20101229162512.GI14221@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201012301103.31085.arnd@arndb.de>
X-Provags-ID: V02:K0:hu3XDd6cd8mbCBiwYMxErfxFI2pwkgNFvIQcIrtJWCi
 eksOH/tWee+X5mdgVVkDSMo5TPmmRxs5t0+h1ANaHRwyHcLw4e
 u8UYJfT6ZjOdFBtCjQegzaY1hlRr8AncyScTXQGFG9r6u6d+g3
 YaF7sMHOst4TwszO0K0f3ZRz+HRGmwt3nEeaXw/sMGkJ5ntDgS
 yy51AVterv9osJ+uzg9wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 December 2010 17:25:12 Uwe Kleine-König wrote:
> some time ago I started to dynamically allocate platform_devices for
> arm/plat-mxc.  For that purpose I added many functions, see
> arch/arm/plat-mxc/include/mach/devices-common.h [1].  Now arm/arch-mxs
> want to do the same, so I wonder if it would be sensible to do something
> like this more globally (either for arm or better kernel global).

Adding platform devices dynamically is definitely the right way forward
for new platforms, as Greg explained recently. The imx_add_platform_device()
function you have defined looks useful for this, and I guess it could
be added globally, next to the existing platform_device_register_resndata,
platform_device_register_data and platform_device_register_simple functions
that we already have doing similar things.

I'm not convinced that the various wrappers you have on imx are the
best solution, though I have not come up with anything better either ;-)

This will also get a lot easier once we have the ability to define
devices in using dtc, because that takes care of the resources.

	Arnd
