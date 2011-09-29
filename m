Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1I2F4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 01:56:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60755 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab1I2F4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 01:56:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6483"; a="123163738"
Message-ID: <4E84088C.8050101@codeaurora.org>
Date: Wed, 28 Sep 2011 22:56:28 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com> <1316793788-14500-2-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1316793788-14500-2-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 09:03 AM, Marc Zyngier wrote:
> The ARM GIC interrupt controller offers per CPU interrupts (PPIs),
> which are usually used to connect local timers to each core.
> Each CPU has its own private interface to the GIC,
> and only sees the PPIs that are directly connect to it.
>
> While these timers are separate devices and have a separate
> interrupt line to a core, they all use the same IRQ number.
>
> For these devices, request_irq() is not the right API as it
> assumes that an IRQ number is visible by a number of CPUs
> (through the affinity setting), but makes it very awkward to
> express that an IRQ number can be handled by all CPUs, and
> yet be a different interrupt line on each CPU, requiring a
> different dev_id cookie to be passed back to the handler.
>
> The *_percpu_irq() functions is designed to overcome these
> limitations, by providing a per-cpu dev_id vector:
>
> int request_percpu_irq(unsigned int irq, irq_handler_t handler,
> 		   const char *devname, void __percpu *percpu_dev_id);
> void free_percpu_irq(unsigned int, void __percpu *);
> int setup_percpu_irq(unsigned int irq, struct irqaction *new);
> void remove_percpu_irq(unsigned int irq, struct irqaction *act);
> void enable_percpu_irq(unsigned int irq);

As mentioned here
https://lkml.org/lkml/2011/9/25/121

can we add irqflags to enable_percpu_irq? This will make msm's
usage cleaner and it wont have to rely on accessing the gic
registers outside the driver.

---
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
