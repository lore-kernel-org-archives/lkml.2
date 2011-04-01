Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab1DAQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:27:24 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58130 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1DAQ1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:27:23 -0400
Date: Fri, 1 Apr 2011 18:26:53 +0200
From: Florian Mickler <florian@mickler.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com
Subject: Re: [PATCH] x86, ioapic: move acpi_get_override_irq to acpi.c
Message-ID: <20110401182653.340abaa4@schatten.dmk.lab>
In-Reply-To: <1301672686-10096-1-git-send-email-florian@mickler.org>
References: <20110401075011.GD7594@elte.hu>
	<1301672686-10096-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Apr 2011 17:44:46 +0200
Florian Mickler <florian@mickler.org> wrote:


> 
> Hi Ingo,
> 
> Instead of exporting find_irq_entry, irq_trigger and irq_polarity, I added a 
> new helper function 'ioapic_get_irq(..)' and exported that. 
> 
> Also I did it as a seperate commit, since it is more of a cleanup and the other 
> commit is already tested... hope this is ok. 
> 
> Regards,
> Flo
> 

btw, include/linux/acpi.h:
120 
121 #ifdef CONFIG_X86_IO_APIC
122 extern int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity);
123 #else
124 #define acpi_get_override_irq(gsi, trigger, polarity) (-1)
125 #endif

this shouldn't be needed anymore, as acpi_get_override_irq is now
independent of CONFIG_X86_IO_APIC (because of ioapic_get_irq having
a placeholder in the !CONFIG_X86_IO_APIC case)

But on the other hand, the code flow for the !CONFIG_X86_IO_APIC would
be kind of silly...  what's the rationale for mp_find_ioapic returning
0 in the !CONFIG_X86_IO_APIC case? And how do I check compilation
of !CONFIG_X86_IO_APIC?   It looks like it already has problems, as
mp_find_ioapic_pin is not stubbed out, or am I overlooking something?

Regards,
Flo
