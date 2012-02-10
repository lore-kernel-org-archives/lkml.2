Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab2BJKQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:16:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45110 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2BJKQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:16:00 -0500
Message-ID: <4F34EE5C.7040103@monstr.eu>
Date: Fri, 10 Feb 2012 11:15:56 +0100
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
References: <4F326A4E.1030106@monstr.eu> <20120208130807.GJ889@n2100.arm.linux.org.uk> <4F3276D6.3060507@monstr.eu> <20120208132622.GL889@n2100.arm.linux.org.uk>
In-Reply-To: <20120208132622.GL889@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Feb 08, 2012 at 02:21:26PM +0100, Michal Simek wrote:
>> First of all I have found how to do it (by CONFIG_PHYS_OFFSET) so the
>> problem is in QEMU.
> 
> So you're basically not telling the kernel about the first 32MB of memory.

It is not a problem.

> 
>> Currently experimenting how to convince CMA to allocate that memory for
>> my purpose.
> 
> Which means it won't be part of the kernels normal memory map, and so
> won't be in the page pool.  So CMA won't be able to help.
> 
> Instead, just ignore the first 32MB of RAM, and map it like any other
> peripheral to gain access to it.  You might need to use ioremap_wc()
> to avoid treating the memory as a 'device type' in ARMv6+.

I switched from cma to dma_declare_coherent_memory which does exactly what I wanted to
do.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
