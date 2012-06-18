Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058Ab2FRLxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:53:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60906 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2FRLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:53:47 -0400
Message-ID: <4FDF16C5.4040304@monstr.eu>
Date: Mon, 18 Jun 2012 13:53:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 4/8] ARM: smp: Move cpu initialization directly to
 ipi_cpu_stop
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-5-git-send-email-monstr@monstr.eu> <20120618113422.GD12029@n2100.arm.linux.org.uk>
In-Reply-To: <20120618113422.GD12029@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 01:34 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 18, 2012 at 01:30:07PM +0200, Michal Simek wrote:
>> This is just preparation patch for dynamic IPI allocation.
>
> Why?

Let's start with this one first.

The reason for dynamic IPI allocation is that IPI interrupts can be used (and I am using them)
for sending IRQ to the second cpu and the second cpu doesn't run Linux.
But still I need functionality for sending interrupts to the second core for Linux. A also need
to have any hook to be able to receive irq from the second core.
Based on that I have looked at this code where only static allocation is used and it is not possible
to use it in this model because no driver can allocate IPI handler.
Based on that I have changed it to model where dynamic IPIs can be allocated dynamically.
As you see from the code. Origin static IPI allocation is still there.

Maybe what it is not visible is that NR_IPI value. As you commented in 5/8 NR_IPI stores number of
IPI used by Linux and I am using is as maximum IPIs in the system.
I am completely fine with not changing NR_IPI value and introduce new one like MAX_NR_IPI value which
will be for Xilinx Zynq GIC setup to 16.

Hope I have clarify it a little bit.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
