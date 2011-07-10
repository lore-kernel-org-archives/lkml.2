Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1GJAI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 20:08:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1GJAIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 20:08:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=b+KpkwmA8P7aWMUs10sdh4kvGQgp6GAw3T2LpcNUHUpeD4zkTjcTWHMnHDjhCcibp
	jQ74DMg9hQUIS5Dzuesfw==
MIME-Version: 1.0
In-Reply-To: <4E18EC41.2080102@ti.com>
References: <1307925960-28839-1-git-send-email-ccross@android.com>
	<4E18EC41.2080102@ti.com>
Date: Sat, 9 Jul 2011 17:08:51 -0700
X-Google-Sender-Auth: Zu5AVqx-7Qld3TGSMSXc17AdDmY
Message-ID: <CAMbhsRRhBc-Ys=nBSB6kHSLUUGB3XD_unN4aG-wubYg0sFer4g@mail.gmail.com>
Subject: Re: [PATCH] ARM: gic: Allow gic arch extensions to provide irqchip flags
From: Colin Cross <ccross@android.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 9, 2011 at 5:03 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On 6/12/2011 5:45 PM, Colin Cross wrote:
>>
>> Tegra can benefit from the IRQCHIP_MASK_ON_SUSPEND flag, allow it
>> to be passed to the gic irq chip.
>>
>> Signed-off-by: Colin Cross<ccross@android.com>
>
> I missed this patch. Looks good to me and I think can
> be merged in rc as well.
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

There is no need for this in an rc unless another patch destined for
rc needs to set the flags, which is unlikely at this point.

>> ---
>>  arch/arm/common/gic.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
>> index 8d62e07..a6c28a0 100644
>> --- a/arch/arm/common/gic.c
>> +++ b/arch/arm/common/gic.c
>> @@ -576,6 +576,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int
>> irq_start,
>>        if (gic_nr == 0)
>>                gic_cpu_base_addr = cpu_base;
>>
>> +       gic_chip.flags |= gic_arch_extn.flags;
>>        gic_dist_init(gic, irq_start);
>>        gic_cpu_init(gic);
>>        gic_cpu_pm_init(gic);
>
> Russell,
> Any thoughts on this fix?
>
> Regards
> Santosh
>
