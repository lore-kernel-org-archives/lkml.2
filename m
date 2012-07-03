Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2GCNBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:01:53 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:37313 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2GCNBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:01:51 -0400
Date: Tue, 3 Jul 2012 15:00:42 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120703130042.GA10007@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
References: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
  <4FECB95D.7010200@zytor.com> <cover.1338222460.git.rubini@gnudd.com>
 <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com>
 <20120701104401.GA4352@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Anvin:
> There is no problem with adding ARM or !X86 dependencies to drivers
> now and fixing them later or as required.

Ok. This is my summary of the compilation errors I have when
enabling ARM_AMBA undex x86 and enabling everything that appears
in "make oldconfig":


This is a sum up of the errors in all driver that are
enabled by telling "CONFIG_ARM_AMBA=y" in the x86 config.

   drivers/dma/pl330.c: register names conflict with arch symbols
     proposed fix: use proper prefix names

   drivers/dma/amba-pl08x.c: needs <asm/hardware/pl080.h>
     proposed fix: move pl080.h to include/linux

   drivers/gpio/gpio-pl061.c: uses chained_irq_enter/exit
     proposed fix: depend on CONFIG_ARM (the function only exists in arm)

   drivers/mmc/host/mmci.c: uses <asm/sizes.h>
   drivers/mmc/host/mmci.c: uses readsl/writesl
     proposed fix: use linux/sizes.h and provide readsl/writesl like others do

   drivers/spi/spi-pl022.c: warning for an integer size mismatch
     proposed fix: none by now

   drivers/watchdog/sp805_wdt.c: uses writel_relaxed
     proposed fix: depend on CONFIG_ARM (this is a spear-only cell by now)


So, if you agree, I would:

    - fix the two dma engines (checking pl080 against russell's pending
    patches)

    - make pl061 and sp805_wdt.c depends on CONFIG_ARM

    - temporarily do the same for mmci, which I'll make work soon as
    I have it under my pci bridge

    - ignore the warning on spi-pl022 until I find a fix

    - resubmit my enabling of arm_amba for x86 and my pci-to-amba bridge
    driver.

thanks
/alessandro
