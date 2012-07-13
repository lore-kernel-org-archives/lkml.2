Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab2GMSyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:54:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44164 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2GMSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:54:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1207131928000.32033@ionos>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com>
 <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 11:53:45 -0700
X-Google-Sender-Auth: 0eGJaMaRE2gwhoNFAWh7MGyvr0M
Message-ID: <CA+55aFwxXPEw-fupEdbCo5eTSC5NPKwvDNkLC9V4NWQ+i3gLxg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:28 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> We already discussed to let the irq chip (in this case MSI) tell the
> core that it does not need the extra oneshot handling. That way the
> code which requests an threaded irq with the NULL primary handler
> works on both MSI and normal interrupts.

So I  don't think your patch is quite right.

If you want to clear the IRQF_ONESHOT for MSI irq's (and other ones
where the interrupt controller is fundamentally ONESHOT), I think you
should do it a few lines higher up - *before* you check the "does the
IRQF_ONESHOT mask match other shared interrupts"?

Now, irq sharing presumably doesn't happen with MSI, but there's
nothing fundamentally wrong with message-based irq schemes that have
shared interrupt handlers.

I think. Hmm?

                  Linus
