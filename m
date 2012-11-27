Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2K0Ijf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:39:35 -0500
Received: from szxga04-in.huawei.com ([119.145.14.67]:39105 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab2K0Ije (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:39:34 -0500
Date: Tue, 27 Nov 2012 09:39:13 +0100
From: Claudio Fontana <Claudio.Fontana@huawei.com>
Subject: [PATCH 0/1 RESEND 2] ARM: plat-versatile: move secondary CPU startup
 out of .init.
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <c.dall@virtualopensystems.com>
Message-id: <50B47C31.2040709@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I am implementing virtual CPU hotplug for the the ARM Cortex A-15 VExpress motherboard.
This is mainly a QEMU feature, which allows dynamically changing the number
of CPUs in the guest.

I stumbled upon a limitation in the kernel support for plat-versatile,
which contains the secondary CPU startup code for the VExpress.

Basically, the secondary CPU startup code is preceded by the macro __INIT,
which causes the code to be freed in free_initmem() during kernel_init().

This means that any attempt at hot-booting CPUs in the guest results in
VCPUs jumping to a memory address that was freed, after which the VCPU
behaves erratically, as can be expected.

With this patch applied, we use __CPUINIT instead of __INIT, so that
the right thing happens:
under CONFIG_HOTPLUG_CPU, the secondary CPU startup code is not freed,
the secondary VCPUs start successfully, and it's all gardens and blue skies.

Tested successfully using the ARM fast models for the Cortex-A15.

--
Claudio Fontana (1):
  ARM: plat-versatile: move secondary CPU startup code out of .init.

 arch/arm/plat-versatile/headsmp.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.12.1


