Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab2ATA3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:29:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37687 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2ATA3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:29:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6594"; a="154176068"
Message-ID: <4F18B577.8080101@codeaurora.org>
Date: Thu, 19 Jan 2012 16:29:43 -0800
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: grant.likely@secretlab.ca, tglx@linutronix.de,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: irq: Allow for specification of no preallocated
 irqs
References: <1327013024-22530-1-git-send-email-mbohan@codeaurora.org> <4F18A18C.9090302@gmail.com>
In-Reply-To: <4F18A18C.9090302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2012 3:04 PM, Rob Herring wrote:
> No doubt that arch_probe_nr_irqs is doing the wrong thing on ARM, but no
> pre-allocation is not what we want either. We ultimately want
> arch_probe_nr_irqs to return NR_IRQS_LEGACY (16) to reserve IRQ0 (aka
> NO_IRQ) and legacy ISA IRQs. With my series, NR_IRQS is set to
> NR_IRQS_LEGACY for SPARSE_IRQ. You can accomplish the same thing without
> that series by setting .nr_irqs to NR_IRQS for non-DT and to
> NR_IRQS_LEGACY for DT. For platforms to work in single kernel builds,
> they will need to select SPARSE_IRQ.

One issue here is that IRQ_BITMAP_BITS is defined as a function of 
NR_IRQS. Currently, there's a hack in place that arbitrarily tacks on 
8196 bits to the end, giving the max virq supported as 8212 with your 
patches. Unfortunately, the system I'm running on will require higher 
values than that, so this actually breaks me.

It seems like the right solution to this problem is to have the 
allocated_irqs bitmap expandable at runtime. Or perhaps use a different 
data structure to begin with?

Mike
