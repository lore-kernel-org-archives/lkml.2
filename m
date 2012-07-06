Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2GFJOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:14:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63142 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2GFJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:14:49 -0400
Message-ID: <4FF6AB0D.8010105@monstr.eu>
Date: Fri, 06 Jul 2012 11:08:29 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
CC: John Linn <linnj@xilinx.com>, John Williams <john.williams@petalogix.com>
Subject: arm cortex a9, smp bootup requirement
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

can someone correct me about smp boot requirement for Linux?

We are fixing ARM zynq smp bootup code and would like to be sure
that out bootup code is correct.

I have found some requirements from standalone boot up code
which is invalidate dcache, icache, branch predictor array
and flush TLB.

I have found in secondary_start_kernel that TLB are flushed
by local_flush_tlb_all function.
But haven't found any cache invalidation calling.

I think it is required and we could be added to platform_secondary_init.

Or is it requirement which has to be fulfil by bootloader before
secondary_startup is called?

We have the option to reset specific cpu in the system and cpu
starts from 0x0 with cache off and in non-virtual mode
where we place simple jump trampoline to the secondary_startup
function. If cache invalidation is required by Linux we can extend this code
to do it.

Jumping trampoline is:
0x0: ldr r0, [8]
0x4: mov pc, r0
0x8: jump address

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
