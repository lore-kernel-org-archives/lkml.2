Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2LAUtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 15:49:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2LAUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 15:49:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philip Balister <philip@balister.org>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Sat, 1 Dec 2012 20:48:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <20121130173644.GA9841@kroah.com> <50B97734.3090207@balister.org>
In-Reply-To: <50B97734.3090207@balister.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212012048.51012.arnd@arndb.de>
X-Provags-ID: V02:K0:3xdUkmC+w28m4KARXCR42MFp1PVksCcOqG6HbBlmOmv
 6r3Bo3AgvEt93vp8BD9wjbKolfdO/MNq0BHvmweX4empyFYsIP
 WMsxJJwP0GcrETKGBEy8YQRv1Nz57AinzgnnaYKRg0DncKt+ie
 Sxy5kLQpglzCjFzWyBHYlbMExQcax0MJ6oIUNdsk+W7f0kSZ7M
 uSOR6XyD1ixCTObO+d1aPeyAP+5Cb/EO4Pxv+el2Tj+35FfJrd
 WbSkGH7jf4EPwjpJ3YrUPzjwlKOx2U7Nfbygd9J773dCj73GcK
 EODlDRwMhJcrBon0SJgwEZqxbXwDXyWMgDoyTB9gA4HOIsZR5s
 hKmUIsNKlSDJ3zea1Bu8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2012, Philip Balister wrote:
> On 11/30/2012 09:36 AM, Greg KH wrote:
> > Yes, I know of at least one more device other than the ones listed above
> > that wants this type of functionality as well, so defining it in a
> > standard user/kernel api manner would be very good to do.
> 
> I'm concerned that a standard driver for FPGA's will be a very difficult 
> problem.
> 
> The Xillybus driver looks interesting on several levels, however my 
> first concern is depends on a FPGA IP block that is not open source. 
> This is not a bad thing, just a potential obstacle for some people.

I agree that is a concern, but for now, I'm mostly worried about
the kernel-to-user interface. If we can agree on a driver interface
that works for Xillybus as well as any of the others we know about,
we can start using that as the generic kernel FPGA interface.

Once we get a second FPGA driver, that can use the same user
interface but talk to the hardware in a different way, and then
we can reorganise the code to keep the user interface bits in a
common driver, away from the hardware specific parts.

If you see anything in the user interface that directly depends on
the Xillybus IP block, then that would make the approach impossible
and we should change that to be more generic.

> I've been engaged in design discussions today with my customer. Our 
> target is the Xilinx Zynq hardware. The first pass at a driver focuses 
> on creating the minimal amount of code in the kernel doing most of the 
> logic in user space. So the driver code allocates a large chunk of RAM 
> for the FPGA to read/write to, provides a mmap function so user space 
> can see this RAM, also mmaps in the address space of an AXI slave so the 
> user space can control the logic. This approach has no dependencies on 
> what is loaded into the fpga.
> 
> This is a very different approach then the Xillybus driver, but should 
> also be useful to a large class of people. Hopefully, we can converge on 
> a set of useful drivers, and not end up with a million drivers all based 
> on custom fpga configuration :)

Agreed. If I understand you correctly though, your approach is specific
to a particular hardware implementation (Zynq) on the user interface layer,
which I think is exactly what we should avoid. Obviously, there is
always a driver involved that is specific to the IP block you load into
an FPGA at runtime, and that is ok. The two parts that I think we
should agree on are:

a) How to get a payload into the FPGA

b) How to find a device driver that can make the payload interface to user
   space.

	Arnd
