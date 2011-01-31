Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1AaW1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:27:25 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41985 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1AaW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:27:24 -0500
Date: Mon, 31 Jan 2011 17:27:20 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Olof Johansson <olof@lixom.net>, john.linn@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
In-Reply-To: <20110131210410.15105.63595.stgit@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1101311709280.8580@xanadu.home>
References: <20110131203626.15105.64302.stgit@localhost6.localdomain6> <20110131210410.15105.63595.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Grant Likely wrote:

> If a dtb is passed to the kernel then the kernel needs to iterate
> through compiled-in mdescs looking for one that matches and move the
> dtb data to a safe location before it gets accidentally overwritten by
> the kernel.
> 
> This patch creates a new function, setup_machine_fdt() which is
> analogous to the setup_machine_atags() created in the previous patch.
> It does all the early setup needed to use a device tree machine
> description.  It also creates arm_unflatten_device_tree() which copies
> the dtb into an allocated buffer and unflattens it into the live-tree
> representation.
> 
> v2: Changed to save the dtb by copying into an allocated buffer.
>     - Since the dtb will very likely be passed in the first 16k of ram
>       where the interrupt vectors live, memblock_reserve() is
>       insufficient to protect the dtb data.

This is wrong.  The vector page can be allocated anywhere.  It is 
currently allocated with memblock_alloc(), so if you memblock_reserve() 
the dtb soon enough then it should be safe and the vector page or 
whatever will be allocated somewhere else.

What was the actual problem?


Nicolas
