Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2BVRgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:36:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2BVRgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:36:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/19] ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
Date: Wed, 22 Feb 2012 17:25:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux@arm.linux.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, rmallon@gmail.com
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <201202221647.23430.arnd@arndb.de> <20120222170724.GF9407@game.jcrosoft.org>
In-Reply-To: <20120222170724.GF9407@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221725.46150.arnd@arndb.de>
X-Provags-ID: V02:K0:byInqVv36wzXJpn0Vukl1vWeWB3FU5lFA2yL+cxXJhq
 ++2HYTfiJeEKaQZXEF1T9sw03yX5sAcJgYd6hV1/7WslZ9kUPR
 k/rmBCLUxn82nDzYyljASwKYW74eRpwdCIisTywuXZFXibQXOh
 6nHo/hMxE7EQO6n+H/ia/kWEqMmBcVYpK2DWXpsG4eefRHZfte
 010vy2F43kKOHzeeyfTkegKnDXcnZ/YMoij5gdbNGsAgPHeQbS
 m0COnVSE65Zc0IIis8rLHIQEWTt+5XuNdI47J9HhCu41W6FkOP
 fV1xI8TyyK/ZO4WhIktygU+s89pya0PpOtejOm382lYxW2iEIZ
 1aWC9/pMOwveyoOcSVNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 February 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > But if you change the rtc driver to always bind to the existing
> > "at91_rtt" platform_device and fail the probe() function for the
> > case that you are on at91sam9263 probing the non-RTC device,
> > you should get the exact same result without any extra code
> > in the per-soc files.
>
> agreed but as on at91sam9263 you have 2 RTTs so you can have 2 drivers at the
> same time that use the RTT. So we can not do this except if we set the second
> RTT to an other device name.

Let me rephrase what I meant then:

The first driver should in its probe function do:

	if (pdev->id != CONFIG_RTC_DRV_AT91SAM9_RTT)
		return -ENODEV;

while the other driver does

	if (pdev->id == CONFIG_RTC_DRV_AT91SAM9_RTT)
		return -ENODEV;

This way, each driver binds to one device but not the other.
It should even work with an unmodified second driver, as long
as you guarantee that it's loaded after the first one.

Any reason why this won't work?

	Arnd
