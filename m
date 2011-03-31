Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1CaItt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:49:49 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:60576 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1CaItr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:49:47 -0400
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics
 are not present
From: Paul Bolle <pebolle@tiscali.nl>
To: Florian Mickler <florian@mickler.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl,
        sedat.dilek@gmail.com, zersaa@gmail.com, stable@kernel.org
Date: Thu, 31 Mar 2011 10:48:43 +0200
In-Reply-To: <1301558489-4198-1-git-send-email-florian@mickler.org>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1301561386.1904.15.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Something, somewhere, chocked on that "[.34+]@schatten.dmk.lab" address
that was in the CC list, so I removed it. Invalid address? Invalid TLD?)

On Thu, 2011-03-31 at 10:01 +0200, Florian Mickler wrote:
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 68df09b..3940103 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3789,6 +3789,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
>  {
>  	int ioapic, pin, idx;
>  
> +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
> +		return -1;
> +
>  	if (skip_ioapic_setup)
>  		return -1;
>  

Seems to have the same goal as commit
678301ecadec24ff77ab310eebf8a32ccddb1850 ("x86, ioapic: Don't warn about
non-existing IOAPICs if we have none"), which got merged in the v2.6.38
cycle (authored by me, signed off by Ingo Molnar). Maybe Eric's patch is
more correct. I can't say as I was happy with the effect of my patch
(ie, make an uninteresting error disappear) and didn't investigate any
further. I have also no desire to dive into this matter again.


Paul

