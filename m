Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab2ATNyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:54:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40700 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2ATNyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:54:36 -0500
Message-ID: <4F197219.4010105@gmail.com>
Date: Fri, 20 Jan 2012 07:54:33 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>
CC: grant.likely@secretlab.ca, tglx@linutronix.de,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: irq: Allow for specification of no preallocated
 irqs
References: <1327013024-22530-1-git-send-email-mbohan@codeaurora.org> <4F18A18C.9090302@gmail.com> <4F18B577.8080101@codeaurora.org>
In-Reply-To: <4F18B577.8080101@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 06:29 PM, Michael Bohan wrote:
> On 1/19/2012 3:04 PM, Rob Herring wrote:
>> No doubt that arch_probe_nr_irqs is doing the wrong thing on ARM, but no
>> pre-allocation is not what we want either. We ultimately want
>> arch_probe_nr_irqs to return NR_IRQS_LEGACY (16) to reserve IRQ0 (aka
>> NO_IRQ) and legacy ISA IRQs. With my series, NR_IRQS is set to
>> NR_IRQS_LEGACY for SPARSE_IRQ. You can accomplish the same thing without
>> that series by setting .nr_irqs to NR_IRQS for non-DT and to
>> NR_IRQS_LEGACY for DT. For platforms to work in single kernel builds,
>> they will need to select SPARSE_IRQ.
> 
> One issue here is that IRQ_BITMAP_BITS is defined as a function of
> NR_IRQS. Currently, there's a hack in place that arbitrarily tacks on
> 8196 bits to the end, giving the max virq supported as 8212 with your
> patches. Unfortunately, the system I'm running on will require higher
> values than that, so this actually breaks me.
> 
> It seems like the right solution to this problem is to have the
> allocated_irqs bitmap expandable at runtime. Or perhaps use a different
> data structure to begin with?

I believe the correct solution is using the radix tree in irqdomain as
Ben H suggested. Does that not work?

Rob
