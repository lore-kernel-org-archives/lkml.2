Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2FGMwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:52:18 -0400
Received: from trent.utfs.org ([94.185.90.103]:55146 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2FGMwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:52:16 -0400
Date: Thu, 7 Jun 2012 05:52:09 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Ethan Zhao <ethan.kernel@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, mcarlson@broadcom.com
Subject: Re: tg3: transmit timed out, resetting
In-Reply-To: <CABawtvNSOkyphUmAU1EoCaCS-hGu-ejPHMmP=j-nRtBZfi7cwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1206070531520.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org> <20120606010255.GA9991@mcarlson.broadcom.com> <alpine.DEB.2.01.1206052314340.5568@trent.utfs.org> <alpine.DEB.2.01.1206070002370.5568@trent.utfs.org>
 <CABawtvNSOkyphUmAU1EoCaCS-hGu-ejPHMmP=j-nRtBZfi7cwg@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012 at 17:47, Ethan Zhao wrote:
>     Could you try 3.5RC1+ with pcie_aspm=off kernel parameter ?

Will try.

> I notice there are some AER errors ( UnsupReq+,RxErr+) with the tg3
> from you lspci output, have you seen the AER errors on console ? if
> so, please attach them.

I haven't seen any actual erros on the console, except these messages 
during bootup:

--------
pci0000:00: Requesting ACPI _OSC control (0x1d)
pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
--------

I have seen these messages in 3.2.0 (an Ubuntu kernel), can't say that I 
have seen them before, they did not show up when I booted this 2.6.38 
Ubuntu kernel.

I'll try booting with pcie_aspm=off and see what it gives...

Thanks,
Christian.

PS: AFAICT, Ubuntu's 2.6.38 [0] had these options set:

--------
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
--------

With 3.5.x, my .config has:

--------
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
--------

[0] https://launchpad.net/ubuntu/natty/i386/linux-image-2.6.38-15-generic/2.6.38-15.60

-- 
BOFH excuse #338:

old inkjet cartridges emanate barium-based fumes
