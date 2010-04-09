Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0DIW4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:56:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0DIW4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:56:35 -0400
Message-ID: <4BBFB07E.9020108@zytor.com>
Date: Fri, 09 Apr 2010 15:55:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio>	<201004071705.07176.bjorn.helgaas@hp.com>	<4BBD13C3.2060404@oracle.com>	<201004091004.39857.bjorn.helgaas@hp.com> <20100409235148.793e4200@lxorguk.ukuu.org.uk>
In-Reply-To: <20100409235148.793e4200@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:51 PM, Alan Cox wrote:
>> Why is this different for 64-bit vs 32-bit?  Can you point me to any
>> references where I can learn about this?
> 
> IMHO its wrong for both
> 
> You can only reserve the region in question if you actually have a VGA
> device and mappings present.
> 
> It's wrong for non PCI systems
> It's wrong for legacy ISA systems with monochrome video/no video
> It's wrong for several embedded platforms.
> It's wrong if PCI isn't your root bridge
> 
> Basically the reservation is the wrong way to fix it. A much saner way to
> fix it would be to simply keep a list of address ranges not to use for
> PCI device relocation. For I/O ports of course we just fix up the PCI
> resources of the device to list them as we discover it (IDE legacy).
>
> You don't want to put anything at the VGA address that needs assigning an
> address. That is *totally* different to the question of whether you want
> to believe the space is 'reserved'. If something is at that address then
> presumably the firmware knows what it is doing. If a device driver wishes
> to reserve that address it's doing so with more information, later in
> boot so should be allowed to.

That's what I mean with reserved, I'm using the term in the
E820_RESERVED sense.  As in "don't put anything there without it being
an explicit assignment".

	-hpa
