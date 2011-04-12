Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab1DLTx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:53:57 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39847 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589Ab1DLTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:53:55 -0400
Date: Tue, 12 Apr 2011 21:53:50 +0200
From: Florian Mickler <florian@mickler.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com
Subject: Re: [PATCH] x86, ioapic: move acpi_get_override_irq to acpi.c
Message-ID: <20110412215350.50fb5cfa@schatten.dmk.lab>
In-Reply-To: <20110412073929.GA26892@elte.hu>
References: <20110401075011.GD7594@elte.hu>
	<1301672686-10096-1-git-send-email-florian@mickler.org>
	<20110412073929.GA26892@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 09:39:29 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Florian Mickler <florian@mickler.org> wrote:
> 
> > In order to get rid of the ugly CONFIG_ACPI ifdef, we move
> > the function acpi_get_override_irq into acpi.c and add a new
> > helper function ioapic_get_irq to io_apic.c.
> > 
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: kurup_avinash@yahoo.com
> > Cc: maciej.rutecki@gmail.com
> > Cc: rjw@sisk.pl
> > Cc: sedat.dilek@gmail.com
> > LKML-Reference: <1301558489-4198-1-git-send-email-florian@mickler.org>
> > ---
> > 
> > Hi Ingo,
> > 
> > Instead of exporting find_irq_entry, irq_trigger and irq_polarity, I added a 
> > new helper function 'ioapic_get_irq(..)' and exported that. 
> > 
> > Also I did it as a seperate commit, since it is more of a cleanup and the other 
> > commit is already tested... hope this is ok. 
> 
> Yeah, looks good in principle.
> 
> Mind porting to the latest x86 devel tree and resend the patch? I tried to 
> apply your patch but there's a conflict. You can find the tree at:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Thanks,
> 
> 	Ingo

It does still apply on top of

[PATCH v2] x86, ioapic: Skip looking for ioapic overrides when ioapics
are not present (<1301621025-3858-1-git-send-email-florian@mickler.org>)

I'm going to send both patches as a reply to this message, since I
have updated the $subject patch to also remove the #define
acpi_get_override_irq in acpi.h ..

Regards,
Flo

