Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0DIWsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:48:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38286 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292Ab0DIWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:48:10 -0400
Date: Fri, 9 Apr 2010 23:51:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai <yinghai.lu@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well as
 x86_32
Message-ID: <20100409235148.793e4200@lxorguk.ukuu.org.uk>
In-Reply-To: <201004091004.39857.bjorn.helgaas@hp.com>
References: <20100407210628.28364.96982.stgit@bob.kio>
	<201004071705.07176.bjorn.helgaas@hp.com>
	<4BBD13C3.2060404@oracle.com>
	<201004091004.39857.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is this different for 64-bit vs 32-bit?  Can you point me to any
> references where I can learn about this?

IMHO its wrong for both

You can only reserve the region in question if you actually have a VGA
device and mappings present.

It's wrong for non PCI systems
It's wrong for legacy ISA systems with monochrome video/no video
It's wrong for several embedded platforms.
It's wrong if PCI isn't your root bridge

Basically the reservation is the wrong way to fix it. A much saner way to
fix it would be to simply keep a list of address ranges not to use for
PCI device relocation. For I/O ports of course we just fix up the PCI
resources of the device to list them as we discover it (IDE legacy).

You don't want to put anything at the VGA address that needs assigning an
address. That is *totally* different to the question of whether you want
to believe the space is 'reserved'. If something is at that address then
presumably the firmware knows what it is doing. If a device driver wishes
to reserve that address it's doing so with more information, later in
boot so should be allowed to.

Alan
