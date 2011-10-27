Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1J0BkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 21:40:22 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:61519 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1J0BkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 21:40:21 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 21:40:20 EDT
Date: Thu, 27 Oct 2011 03:17:38 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        giancarlo.asnaghi@st.com
Subject: x86/Kconfig: where to place a new chipset
Message-ID: <20111027011737.GA17910@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm currently working on a PCIe chipset (or IO-Hub), called STA2X11.
The device hosts a number of peripherals (sata, ether, spi, uart, ...)
and a DMA controller.  The individual PCI functions can't be enabled
by themselves, as chip support must be activated first.  This is both
because some internal mappings must be setup and because internal
device functions rely on the internal DMA engine. Actually, an
instance of swiotlb is being used.

While I'm sure core code should be in arch/x86/platform (and there is
where I placed the initialization code), I'm wondering where should
the device fall in the Kconfig tree. I tend to put it in the
X86_32_NON_STANDARD stanza, even if the resulting kernel will also
work on standard computers (the "SGI Visual Workstation" config option
does the same).

On the other hand, the device can either be the core chipset (main use
case) or it can be plugged on a PCIe board.

Any suggestion is welcome about Kconfig placement.  Being a "vi
.config" and "make oldconfig" kind of guy, I can't really understand
the manu layout, so I'm finding a hard time in making a sensible
choice.

thanks
/alessandro
