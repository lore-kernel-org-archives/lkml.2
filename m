Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1JBSBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:01:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1JBSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:01:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right DMA method
Date: Sun, 02 Oct 2011 20:00:31 +0200
Message-ID: <1757336.Qk72n3s00p@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002161447.GC12323@n2100.arm.linux.org.uk>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-16-git-send-email-arnd@arndb.de> <20111002161447.GC12323@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cRlO3zO2TYxvJZlssNr6TdU9ZmfvzLH2yaOd6Iarg+Z
 Nw03Y9ivjI3azSM+5oBhI5a8K2sRaY9WA7ebrz1se9meG6xGrD
 14aJUqsguwP2DztkERTZF5076GZT0UCCDsmXiXzY8cbGpNIcv3
 lBZgeFjMO7Tf7435vilb5L7u6cXuy780FBnOH+a+UUmgdUQB9e
 PR8EEWXB3Ml9SU5UKKR35R+F683yPpe0Ea7fTzd/2Ga3MARg2z
 fNyMNfUUwgb1qao2D9rIyuvU9UvNJCQ4sM1XLLlsEFkpof8bgV
 0OVRJJqZ7ZEZSdd0qXotl3TikIkcnbH6tijvFwKqBqyMoz8BGf
 Hdl/EuwnklbNaxAVpsTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 17:14:47 Russell King - ARM Linux wrote:
> On Sun, Oct 02, 2011 at 04:45:45PM +0200, Arnd Bergmann wrote:
> > The logic to allow only one DMA driver in MUSB is currently
> > flawed, because it also allows picking no DMA driver at all
> > and also not selecting PIO mode.
> > 
> > Using a choice statement makes this foolproof for now and
> > also simplifies the Makefile.
> > 
> > Unfortunately, we will have to revisit this when we start
> > supporting multiple ARM platforms in a single kernel binary,
> > because at that point we will actually need to select
> > multiple DMA drivers and pick the right one at run-time.
> 
> I thought there was some work going on to convert this to use the
> dmaengine stuff?

That would certainly be the best solution here, I wasn't aware
that it has already been discussed.

Unfortunately, even with the dma parts out of the way there is
a lot that needs to be done to make musb, ehci or ohci
really cross-platform. Right now, you can only have one
platform driver glue for each of those drivers, and they
should eventually be converted to a large library module for
the core, with independent platform driver front-end, similar
to the recent conversion of the sdhci driver by Shawn Guo,
and the way that a lot of the other common drivers work.

	Arnd
