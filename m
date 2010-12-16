Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0LPOy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:54:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32909 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0LPOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:54:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="67085621"
Message-ID: <4D0A281F.1090705@codeaurora.org>
Date: Thu, 16 Dec 2010 09:54:23 -0500
From: Stephen Caudle <scaudle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11pre) Gecko/20100922 Shredder/3.1.5pre
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        adharmap@codeaurora.org, linux-kernel@vger.kernel.org, miltonm@bga.com,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] [ARM] gic: Unmask private interrupts on all cores
 during IRQ enable
References: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org> <20101130180718.GB8521@n2100.arm.linux.org.uk> <4CF6797A.2010807@codeaurora.org> <20101201171425.GA29347@n2100.arm.linux.org.uk> <4D0102B3.8010302@codeaurora.org>
In-Reply-To: <4D0102B3.8010302@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 11:24 AM, Stephen Caudle wrote:
>> It is also unreasonable to have one core enabling the PPI on other
>> cores where the hardware behind the interrupt may not have been
>> initialized yet.  If it is a private interrupt for a private peripheral,
>> then only the associated CPU should be enabling that interrupt.
>>
>> I guess this is something which genirq can't cope with, in which case
>> either genirq needs to be modified to cope with private CPU interrupts,
>> which are controlled individually by their associated CPU, or we need a
>> private interface to support this.
> 
> I see your point.  Our immediate need for this is to support a
> performance monitor interrupt that happens to be a PPI.  It is used by
> perf events (and subsequently, oprofile).
> 
> Since PPIs are so machine-specific, I started looking into patching
> perf_events.c by adding a machine specific function to handle the PMU
> IRQ request.  For mach-msm, we would call request_irq like normal, but
> also unmask the performance monitor interrupt on the other cores.  The
> downside to this is that a machine specific implementation would be
> needed anytime a PPI is requested, not just in perf_events.c.
> 
> Then, I saw Thomas' email regarding our local timer PPI:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/033840.html.
> 
> Russell, before I submit another patch, I would like to know if you
> prefer a more generic approach like Thomas suggests, or a
> machine-specific approach like I have described?

Russell, what are your thoughts on this?

Thanks,
Stephen

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
