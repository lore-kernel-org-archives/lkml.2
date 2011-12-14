Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1LNPlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:41:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab1LNPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:41:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
Date: Wed, 14 Dec 2011 15:40:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com> <1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com> <74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112141540.49243.arnd@arndb.de>
X-Provags-ID: V02:K0:vdriDTdNibZ7EzQHtpm3qdh9HSDStp290H2JBQdj65S
 Q/3LF1hoZp9IwdK+8KGZZNK7rG/ykUbDfOLsPpTfktU/jQWhSQ
 hu4JE7WfJM3uKWuoUn/ZWhiG42KQTeMLJDZ5O2pNcUiq9yHHaf
 0s/k9CNjPHtaPu6FdpEdB54X3H/BiUEHd1dyBwDq7DgRwcbtS4
 PiN3YFWTyHOWNW7/P9gRIN2xpniNJGzP2+TcRersA476yAj/cE
 h2fPEXFnAJJ7517EbowtdgiXWGRO3ubOOnnVhjGMStesXC9DVw
 xXm/uJP26tnv0mrY4f5zCuqqlb7Nq1g4tNWaYvt7b7bOq+ryrc
 UeDtHVmNe+sSvbCzgCdA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 December 2011, Stephen Warren wrote:
> Haojian Zhuang wrote at Tuesday, December 13, 2011 2:41 AM:
> 
> > diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> 
> > +obj-$(CONFIG_PINMUX_PXA168)	+= pinmux-pxa168.o pinctrl-pxa3xx.o
> > +obj-$(CONFIG_PINMUX_PXA300)	+= pinmux-pxa300.o pinctrl-pxa3xx.o
> > +obj-$(CONFIG_PINMUX_PXA910)	+= pinmux-pxa910.o pinctrl-pxa3xx.o
> 
> That structure will cause problems if multiple of those Kconfig options
> are enabled at once, as in a multi-SoC kernel. Instead, shouldn't this be:
> 
> obj-$(CONFIG_PINCTRL_PXA3XX)	+= pinctrl-pxa3xx.o
> obj-$(CONFIG_PINMUX_PXA168)	+= pinmux-pxa168.o
> obj-$(CONFIG_PINMUX_PXA300)	+= pinmux-pxa300.o
> obj-$(CONFIG_PINMUX_PXA910)	+= pinmux-pxa910.o

I'm pretty sure the first version is ok too, as long as none of the
options can be built as modules.  Your version seems to be more common though.

	Arnd
