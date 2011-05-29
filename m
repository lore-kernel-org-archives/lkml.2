Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1E2Igm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:36:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36856 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1E2Igk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eHBg8NTVpz/QuPu3a6ZdwSaPS6YI9FtuRT8efqC1AB2xbDpZABloabNLjydilj8e2x
         1nwHUVQRhFytEMLuRzYOe4MS2bP0tVNjX9xO/ov/STn9LN0LDD8WKWXLxj9h+sIdmmHd
         OY2l7j1F+WWB3CQ+FUB+vDvv5zlHa2u3FAvuc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net>
	<alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com>
Date: Sun, 29 May 2011 12:36:39 +0400
Message-ID: <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com>
Subject: Re: IrDA driver fails on PXA255
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 29, 2011 at 3:34 AM, David Rientjes <rientjes@google.com> wrote:
> On Sun, 29 May 2011, Dmitry Eremin-Solenikov wrote:
>
>> Hello,
>>
>> Since a197b59ae6e8bee56fcef37ea2482dc08414e2ac (mm: fail GFP_DMA
>> allocations when ZONE_DMA is not configured), pxaficp_ir.c driver fails
>> to probe: pxa_irda_init_iobuf asks for a buffer with GFP_KERNEL |
>> GFP_DMA flags, which fail nicely with the following trace:
>>
>> ------------[ cut here ]------------
>> WARNING: at mm/page_alloc.c:2251
>> __alloc_pages_nodemask+0xa0/0x5ac()
>> Modules linked in:
>> [<c00385b0>] (unwind_backtrace+0x0/0xf0) from [<c0050b1c>] (warn_slowpath_common+0x4c/0x64)
>> [<c0050b1c>] (warn_slowpath_common+0x4c/0x64) from [<c0050b4c>] (warn_slowpath_null+0x18/0x1c)
>> [<c0050b4c>] (warn_slowpath_null+0x18/0x1c) from [<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac)
>> [<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac) from [<c0090e74>] (__get_free_pages+0x10/0x3c)
>> [<c0090e74>] (__get_free_pages+0x10/0x3c) from [<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48)
>> [<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48) from [<c01d61d8>] (pxa_irda_probe+0x11c/0x32c)
>> [<c01d61d8>] (pxa_irda_probe+0x11c/0x32c) from [<c019474c>] (platform_drv_probe+0x14/0x18)
>> [<c019474c>] (platform_drv_probe+0x14/0x18) from [<c0193508>] (really_probe+0xa0/0x158)
>> [<c0193508>] (really_probe+0xa0/0x158) from [<c019360c>] (driver_probe_device+0x4c/0x64)
>> [<c019360c>] (driver_probe_device+0x4c/0x64) from [<c0193684>] (__driver_attach+0x60/0x84)
>> [<c0193684>] (__driver_attach+0x60/0x84) from [<c0192d78>] (bus_for_each_dev+0x48/0x84)
>> [<c0192d78>] (bus_for_each_dev+0x48/0x84) from [<c01926b8>] (bus_add_driver+0xa8/0x220)
>> [<c01926b8>] (bus_add_driver+0xa8/0x220) from [<c0193c7c>] (driver_register+0xac/0x13c)
>> [<c0193c7c>] (driver_register+0xac/0x13c) from [<c0033440>] (do_one_initcall+0x94/0x16c)
>> [<c0033440>] (do_one_initcall+0x94/0x16c) from [<c00083f4>] (kernel_init+0x94/0x140)
>> [<c00083f4>] (kernel_init+0x94/0x140) from [<c00348d0>] (kernel_thread_exit+0x0/0x8)
>> ---[ end trace 0b8bf08f70147098 ]---
>>
>
> The driver is attempting to allocate DMA memory and you have
> CONFIG_ZONE_DMA disabled, which is the only reason you would get this
> warning.  If the allocation did not fail as a result of a197b59ae6e8, the
> page allocator may return any memory in a higher zone that the driver may
> not be expecting.  If you had never noticed a problem before, it may be
> possible that the driver doesn't actually have any zone restrictions and
> GFP_DMA can be removed, but this code is pretty old.  Otherwise, it'll
> need to depend on ZONE_DMA in the Kconfig.

What about changing your patch for less intrusive one (to emit a
WARN_ON) for at least one
or two major releases and only then changing it back to the current state?

-- 
With best wishes
Dmitry
