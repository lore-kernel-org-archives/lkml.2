Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0I3W4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:56:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42106 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0I3W4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:56:52 -0400
Message-ID: <4CA515AA.7060400@zytor.com>
Date: Thu, 30 Sep 2010 15:56:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Avinash Kurup <kurup.avinash@gmail.com>
Subject: Re: [PATCH] Skip looking for ioapic overrides when ioapics are not
 present
References: <AANLkTilT0cPU8y2m4ZeatfvtflAagSyQEP9JubqZ6TeW@mail.gmail.com> <m17hmcke5m.fsf@fess.ebiederm.org>
In-Reply-To: <m17hmcke5m.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2010 08:56 PM, Eric W. Biederman wrote:
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 33f3563..226a6d1 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -4066,6 +4066,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
>  {
>  	int ioapic, pin, idx;
>  
> +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
> +		return -1;
> +
>  	if (skip_ioapic_setup)
>  		return -1;
>  

I was just poked about this patch... it doesn't build "make allnoconfig"
on x86-64.

This is also a bugzilla ticket now:
https://bugzilla.kernel.org/show_bug.cgi?id=17772

	-hpa
