Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1IMPmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:42:54 -0400
Received: from mail-gx0-f170.google.com ([209.85.161.170]:35443 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1IMPmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:42:52 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 11:42:52 EDT
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
Date: Tue, 13 Sep 2011 10:35:29 -0500
Message-ID: <CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
From: Jon Mason <mason@myri.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        Alan Piszcz <ap@solarrain.com>, NetDEV list <netdev@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 9:54 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Tue, 13 Sep 2011, Eric Dumazet wrote:
>
>> Please Justin make sure you pulled commit
>> commit ed2888e906b56769b4ffabb9c577190438aa68b8
>> Author: Jon Mason <mason@myri.com>
>> Date:   Thu Sep 8 16:41:18 2011 -0500
>>
>>   PCI: Remove MRRS modification from MPS setting code
>>
>>   Modifying the Maximum Read Request Size to 0 (value of 128Bytes) has
>>   massive negative ramifications on some devices.  Without knowing which
>>   devices have this issue, do not modify from the default value when
>>   walking the PCI-E bus in pcie_bus_safe mode.  Also, make pcie_bus_safe
>>   the default procedure.
>>
>>   Tested-by: Sven Schnelle <svens@stackframe.org>
>>   Tested-by: Simon Kirby <sim@hostway.ca>
>>   Tested-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>   Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
>>   Reported-and-tested-by: Niels Ole Salscheider
>> <niels_ole@salscheider-online.
>>   References: https://bugzilla.kernel.org/show_bug.cgi?id=42162
>>   Signed-off-by: Jon Mason <mason@myri.com>
>>   Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>>   Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> Hello,
>
> I found this commit here:
> http://permalink.gmane.org/gmane.linux.kernel.pci/11700

This is an early version of the patch.  This is the patch that you want:
https://github.com/torvalds/linux/commit/ed2888e906b56769b4ffabb9c577190438aa68b8

It appears that this patch didn't make it to lkml or linux-pci list
due to kernel.org DNS being down when it was sent.

Thanks,
Jon

>
> Applied:
> # patch -p1 < ../ed2888e906b56769b4ffabb9c577190438aa68b8.txt patching file
> drivers/pci/probe.c
>
> I will update this thread if the problem recurs, can someone also please
> advise
> which DEBUG options I should have enabled to catch further SLAB/RCU issues?
>
> So far, I have the following enabled:
>
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SLAB=y
> CONFIG_DEBUG_SLAB_LEAK=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_STACK_USAGE=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_RODATA=y
>
> Thanks,
>
> Justin.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
