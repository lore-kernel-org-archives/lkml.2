Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1AaXDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:03:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57881 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1AaXDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:03:45 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101311709280.8580@xanadu.home>
References: <20110131203626.15105.64302.stgit@localhost6.localdomain6>
 <20110131210410.15105.63595.stgit@localhost6.localdomain6> <alpine.LFD.2.00.1101311709280.8580@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 16:03:24 -0700
X-Google-Sender-Auth: OePdK8OS1W5y1o4Y9ZY4VJdJiwc
Message-ID: <AANLkTi=Kfb6TVUqN9aogq8A5WskNfwW=s7Dswgf2MC8i@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Olof Johansson <olof@lixom.net>, john.linn@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 3:27 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Mon, 31 Jan 2011, Grant Likely wrote:
>
>> If a dtb is passed to the kernel then the kernel needs to iterate
>> through compiled-in mdescs looking for one that matches and move the
>> dtb data to a safe location before it gets accidentally overwritten by
>> the kernel.
>>
>> This patch creates a new function, setup_machine_fdt() which is
>> analogous to the setup_machine_atags() created in the previous patch.
>> It does all the early setup needed to use a device tree machine
>> description.  It also creates arm_unflatten_device_tree() which copies
>> the dtb into an allocated buffer and unflattens it into the live-tree
>> representation.
>>
>> v2: Changed to save the dtb by copying into an allocated buffer.
>>     - Since the dtb will very likely be passed in the first 16k of ram
>>       where the interrupt vectors live, memblock_reserve() is
>>       insufficient to protect the dtb data.
>
> This is wrong.  The vector page can be allocated anywhere.  It is
> currently allocated with memblock_alloc(), so if you memblock_reserve()
> the dtb soon enough then it should be safe and the vector page or
> whatever will be allocated somewhere else.

Ah, thanks.  Did not know that.

> What was the actual problem?

I was seeing the first page in memory getting zeroed partway through
the boot process which wiped out the dtb.  I haven't yet narrowed down
to the exact point that it gets overwritten.  It is late enough that
all the early setup dt code works, but before init_machine gets
called.

I'm also seeing a problem with /proc/device-tree getting corrupted on
qemu which I cannot reproduce on Tegra hardware.  Still investigating
this one.

g.
