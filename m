Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2FRLl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:41:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60483 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2FRLl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:41:57 -0400
Message-ID: <4FDF1400.6090402@monstr.eu>
Date: Mon, 18 Jun 2012 13:41:52 +0200
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
Subject: Re: [RFC PATCH 1/8] ARM: gic: Support forcing cpumask for possible
 cpus in the system
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-2-git-send-email-monstr@monstr.eu> <20120618113339.GC12029@n2100.arm.linux.org.uk>
In-Reply-To: <20120618113339.GC12029@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 01:33 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 18, 2012 at 01:30:04PM +0200, Michal Simek wrote:
>> gic_set_affinity doesn't support force option. Force option
>> should work with all possible cpus in the system not only with
>> online cpus.
>
> Neither does x86.  Why do you want this?  Offline CPUs are unable to
> receive the interrupt in any case (and must not receive interrupts in
> the bringup path until they are online.)

The whole reason for all these changes in AMP on dual core Cortex A9 where
on one cpu runs Linux and on the second RTOS/standlone.

It means that the second cpu is from Linux point of view offline all the time.
But GIC has to be (and can be) setup to forward IRQ directly to the second cpu.
GIC should be controlled by Linux.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
