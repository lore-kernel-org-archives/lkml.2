Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2EARb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:31:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2EARbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:31:24 -0400
Date: Tue, 1 May 2012 13:12:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>
Subject: Re: Oops in 3.0.30/fsl_usb2_device_register
Message-ID: <20120501171217.GA7111@kroah.com>
References: <20120501162253.GA2596@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501162253.GA2596@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 09:22:53AM -0700, Guenter Roeck wrote:
> Hi all,
> 
> I see the following oops in 3.0.30. This is with a Freescale 8536.
> 
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc03f7e0c
> Oops: Kernel access of bad area, sig: 11 [#1]
> PREEMPT SE8000_lc8536
> Modules linked in:
> NIP: c03f7e0c LR: c03f7dd4 CTR: 00000000
> REGS: ef837d50 TRAP: 0300   Not tainted  (3.0.30-767-gfd1550a)
> MSR: 00029000 <EE,ME,CE>  CR: 82002024  XER: 20000000
> DEAR: 00000000, ESR: 00800000
> TASK = ef838000[1] 'swapper' THREAD: ef836000
> GPR00: ef912008 ef837e00 ef838000 ef8cbc00 ef837e28 00000050 00000000 00000000
> GPR08: 00000000 00000000 ffffffff ef9120f0 24002024 1017f868 deabfc4c 72947cde
> GPR16: 31e01609 00000800 00000000 04100000 1f07fde8 1f180000 c09c8000 fffff000
> GPR24: ef837e28 c0ae7d14 c09c75b4 ef906ae0 00000002 ef837e28 ef8cbc00 ef912000
> NIP [c03f7e0c] fsl_usb2_device_register+0x74/0xf8
> LR [c03f7dd4] fsl_usb2_device_register+0x3c/0xf8
> Call Trace:
> [ef837e00] [c03f7dd4] fsl_usb2_device_register+0x3c/0xf8 (unreliable)
> [ef837e20] [c03f819c] fsl_usb2_mph_dr_of_probe+0x238/0x2bc
> [ef837ea0] [c0285a00] platform_drv_probe+0x20/0x30
> [ef837eb0] [c0283e6c] driver_probe_device+0xc8/0x1f8
> [ef837ed0] [c0284070] __driver_attach+0xd4/0xd8
> [ef837ef0] [c02833fc] bus_for_each_dev+0x7c/0xc4
> [ef837f20] [c0283c34] driver_attach+0x24/0x34
> [ef837f30] [c0282aa0] bus_add_driver+0xdc/0x2dc
> [ef837f60] [c0284900] driver_register+0x94/0x198
> [ef837f80] [c028609c] platform_driver_register+0x6c/0x7c
> [ef837f90] [c04dd288] fsl_usb2_mph_dr_init+0x18/0x28
> [ef837fa0] [c0001ddc] do_one_initcall+0x50/0x200
> [ef837fd0] [c04bf1bc] kernel_init+0x9c/0x14c
> [ef837ff0] [c000dd28] kernel_thread+0x4c/0x68
> Instruction dump:
> 813f0080 381f0008 815f0084 7fa4eb78 901e0008 38a00050 913e0080 915e0084
> 817f0078 811e0078 812b0000 814b0004
>  91480004 4be8e679 2c030000
>  ---[ end trace 3a8eb627b8e9e0fb ]---
> 
> Problem was introduced with commit d39514c14bd941232976b68e2750dc725b90e724.
> The commit claims that dma_mask is already set in arch_setup_pdev_archdata().
> However, that only seems to be true for the current kernel, not for 3.0.
> As a result, dma_mask is NULL in fsl_usb2_device_register, causing the above oops.
> 
> Question now is if d39514c14bd941232976b68e2750dc725b90e724 should be reverted from 3.0,
> or if there is a better solution. Any thoughts/ideas ?

This patch is already queued up to be reverted from the next 3.0-stable
release, so yes, it should be reverted :)

The next 3.0-stable tree should have this fixed for you, sorry about
that.

greg k-h
