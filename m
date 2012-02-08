Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2BHNaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:30:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44543 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2BHNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:30:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Wed, 08 Feb 2012 14:30:02 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: CMA on arm from zero address
In-reply-to: <4F3276D6.3060507@monstr.eu>
To: monstr@monstr.eu, "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.arm.linux.org.uk
Message-id: <000c01cce665$c3394ee0$49abeca0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczmZJSI7spaD98qQoqigM+FBmgeowAAIR6w
References: <4F326A4E.1030106@monstr.eu>
 <20120208130807.GJ889@n2100.arm.linux.org.uk> <4F3276D6.3060507@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, February 08, 2012 2:21 PM Michal Simek wrote:

> Russell King - ARM Linux wrote:
> > On Wed, Feb 08, 2012 at 01:27:58PM +0100, Michal Simek wrote:
> >> Hi,
> >>
> >> I would like to setup CMA space at the beginning of ram because
> >> I want to use remoteproc to run code on the second cpu which has to
> >> use addresses 0x0 - 32MB.
> >>
> >> I have changed textofs in arch/arm/Makefile but there is not possible
> >> to setup all values which I would like to use.
> >
> > What a broken setup.  Placing the kernel outside of the 16MB window
> > effectively prevents you from using modules.  Why do people come up
> > with stupid things like this.  Please stop.  Put such things at the
> > end of RAM instead and save the rest of the ARM community from this
> > madness.
> 
> First of all I have found how to do it (by CONFIG_PHYS_OFFSET) so the problem is in QEMU.
> Currently experimenting how to convince CMA to allocate that memory for my purpose.

I'm not sure if CMA is the right allocation api for this purpose. You should
better use memblock allocator to grab specific address ranges for your custom 
setup. Alternatively you can compile Linux kernel to start physical memory 
at 16MiB and access the 0-16MiB range with ioremap for example.

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


