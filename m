Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2BHNVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:21:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab2BHNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:21:30 -0500
Message-ID: <4F3276D6.3060507@monstr.eu>
Date: Wed, 08 Feb 2012 14:21:26 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: CMA on arm from zero address
References: <4F326A4E.1030106@monstr.eu> <20120208130807.GJ889@n2100.arm.linux.org.uk>
In-Reply-To: <20120208130807.GJ889@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Russell King - ARM Linux wrote:
> On Wed, Feb 08, 2012 at 01:27:58PM +0100, Michal Simek wrote:
>> Hi,
>>
>> I would like to setup CMA space at the beginning of ram because
>> I want to use remoteproc to run code on the second cpu which has to
>> use addresses 0x0 - 32MB.
>>
>> I have changed textofs in arch/arm/Makefile but there is not possible
>> to setup all values which I would like to use.
> 
> What a broken setup.  Placing the kernel outside of the 16MB window
> effectively prevents you from using modules.  Why do people come up
> with stupid things like this.  Please stop.  Put such things at the
> end of RAM instead and save the rest of the ARM community from this
> madness.

First of all I have found how to do it (by CONFIG_PHYS_OFFSET) so the problem is in QEMU.
Currently experimenting how to convince CMA to allocate that memory for my purpose.

That idea doesn't come from me!
The reason is that we want to run Linux on the first ARM core and the second cpu
will run any other RTOS. Linux remaps vectors to 0xffff0000 and the second
core has to use them at 0x0 address.
RTOS runs in real mode that's why I need to use ram at 0x0 address.

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
