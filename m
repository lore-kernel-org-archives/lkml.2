Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1BNLCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:02:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1BNLCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:02:41 -0500
Date: Mon, 14 Feb 2011 12:02:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: mingo@readhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        tj@kernel.org, yinghai@kernel.org, ak@linux.intel.com,
        robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86: ifdef INTR_REMAP code out
Message-ID: <20110214110231.GB7140@elte.hu>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
 <1297677612-12405-3-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297677612-12405-3-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrik Kretzschmar <henne@nachtwindheim.de> wrote:

> +#ifdef CONFIG_INTR_REMAP
> +	struct IO_APIC_route_entry **ioapic_entries = NULL;
> +
>  	if (intr_remapping_enabled) {
>  		ioapic_entries = alloc_ioapic_entries();
>  		if (!ioapic_entries) {
> @@ -2133,6 +2136,7 @@ static int lapic_resume(struct sys_device *dev)
>  		mask_IO_APIC_setup(ioapic_entries);
>  		legacy_pic->mask_all();
>  	}
> +#endif
>  
>  	if (x2apic_mode)
>  		enable_x2apic();
> @@ -2173,6 +2177,7 @@ static int lapic_resume(struct sys_device *dev)
>  	apic_write(APIC_ESR, 0);
>  	apic_read(APIC_ESR);
>  
> +#ifdef CONFIG_INTR_REMAP
>  	if (intr_remapping_enabled) {
>  		reenable_intr_remapping(x2apic_mode);
>  		legacy_pic->restore_mask();
> @@ -2180,6 +2185,7 @@ static int lapic_resume(struct sys_device *dev)
>  		free_ioapic_entries(ioapic_entries);
>  	}
>  restore:
> +#endif

Hm, these bits should be factored out in a cleaner fashion - by adding helper 
functions, etc. The x2apic code's integration into the lapic code was done in a 
pretty ugly fashion so it's not your fault - but if we want to reintroduce UP-IOAPIC 
we need to do it cleanly.

Do you still want to do it? :-)

Thanks,

	Ingo
