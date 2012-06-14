Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2FNIF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:05:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2FNIFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:05:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/3] i2c-nomadik: turn the platform driver to an amba driver
Date: Thu, 14 Jun 2012 08:04:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, Lee Jones <lee.jones@linaro.org>,
        Alan Cox <alan@linux.intel.com>
References: <cover.1339447570.git.rubini@gnudd.com> <4a198618063924b68182279ffd56c335d621f542.1339447570.git.rubini@gnudd.com>
In-Reply-To: <4a198618063924b68182279ffd56c335d621f542.1339447570.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206140804.39083.arnd@arndb.de>
X-Provags-ID: V02:K0:yZHC88KwugOpF1wAtwSKMmfAAvdtrv3iYSaolZgXOGg
 au8iisUNUSJMsQpam4xjA4iX3c1xDJAo9B3xZnpioW+dMEg5gf
 JSOi7FAE/7jnXr6es3x89r+wuoRkX+fm3ElO3nLRV1zlG1tLgl
 wTRnahkmDDAF7mLFmoiU3kZj6XaP2LFf/56UOSKchuM3PDAlo8
 GZuzEIzW0oyBsYo7Q2hFHMEVJjGEvRot3QHvzosYpY5VO1qWt2
 kQY1II/cv0gB5kTxlP3wdb+az4aKqImuuGue5+RE6bsalq8U9u
 t1edJ8LYmdPWjzCnehicPjQ1F28ZgCd0ozKwPg31jHSAXvhz4A
 SLD5y+PzyiXANce9Er7M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Alessandro Rubini wrote:
> The i2c-nomadik gateware is really a PrimeCell APB device. By hosting
> the driver under the amba bus we can access it more easily, for
> example using the generic pci-amba driver. The patch also fixes the
> mach-ux500 users, so they register an amba device instead than a
> platform device.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-ux500/devices-common.h |   22 +----
>  drivers/i2c/busses/i2c-nomadik.c     |  142 +++++++++++++++++----------------
>  2 files changed, 78 insertions(+), 86 deletions(-)

You change only one half of ux500 here: the part where the device gets defined
statically, but not not the definition in the device-tree.

I think all you need to do is mark the device compatible with primecell
and add an ID if necessary, but we should definitely make sure that that
path still works, because the one you patch is going away.

	Arnd
