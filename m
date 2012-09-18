Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2IRIdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:33:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab2IRIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:32:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 24/24] net: seeq: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 08:14:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        netdev@vger.kernel.org
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <20120914235607.GF12245@n2100.arm.linux.org.uk> <20120915.000059.636218745264773259.davem@davemloft.net>
In-Reply-To: <20120915.000059.636218745264773259.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209180814.38975.arnd@arndb.de>
X-Provags-ID: V02:K0:ho2pxhQHIuA6ntBWHmWkU83c0unYh4sL8BCbd4HFEVv
 Fl49HQYVRbBHPeaN3+wU54/gO/w4w0/WLsGq1+k/rzhw1sau0H
 1/CwLVRiIZOOsspZwLQjkLvWE0AEIUKuLrMfEIhogdfTRB0E8M
 lWnqavap25K8OGfPNIJB7Y2CGieKc+HDZqVh+l0RRn7/HqwixI
 Tj8nT1gaKZhdgoWXhhVHA86cp2RBAhpshQq3s4I5CysmI+7Zc/
 8yAdndbyRf5szpel6kNUcAd0I4unpt/yduL5UDe1Y08z+o7vqK
 +fuRRSZDNgMB2WxsZLQka2NwEcJ7piW5gapgptlmNnECcLKAh7
 8XJaH0I8Zca6+zKoHQos=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2012, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Sat, 15 Sep 2012 00:56:07 +0100
> 
> > On Fri, Sep 14, 2012 at 11:34:52PM +0200, Arnd Bergmann wrote:
> >> ARM is moving to stricter checks on readl/write functions,
> >> so we need to use the correct types everywhere.
> > 
> > Same comment as for eesox.  const void __iomem * is not a problem on
> > x86, so it should not be a problem on ARM.
> 
> Agreed.

As discussed in the thread for the same patch on the scsi eesox driver,
x86 allows reads on const __iomem pointers, but not writes, and the patch
to asm/io.h that Russell has queued up changes ARM to do the same.

My patch on seeq/ether3.c is still needed to avoid this warning in
linux-next:

drivers/net/ethernet/seeq/ether3.c: In function 'ether3_outb':
drivers/net/ethernet/seeq/ether3.c:104:2: error: passing argument 2 of '__raw_writeb' discards 'const' qualifier from pointer target type
arch/arm/include/asm/io.h:81:91: note: expected 'volatile void *' but argument is of type 'const void *'

	Arnd
