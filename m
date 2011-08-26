Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1HZVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:09:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53758 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754149Ab1HZVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:09:26 -0400
X-Authenticated: #28077480
X-Provags-ID: V01U2FsdGVkX1+qQ9RN6Piq0yaVNJLzM3CDvIDPSGWI5N4wY8LwKf
	Zi/z2gnq2isVWa
From: Ralf Jung <ralfjung-e@gmx.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Fwd: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Date: Fri, 26 Aug 2011 23:09:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc3-custom+; KDE/4.6.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <CAErSpo5kEw=VTVv-=_D3hQg5oRNL9yEyJUnpP0biH=t3WRXMZw@mail.gmail.com>
In-Reply-To: <CAErSpo5kEw=VTVv-=_D3hQg5oRNL9yEyJUnpP0biH=t3WRXMZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108262309.20742.ralfjung-e@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Ralf Jung <ralfjung-e@gmx.de>

Thanks a lot!
Ralf

On Friday 26 August 2011 01:08:19 Bjorn Helgaas wrote:
> FYI.  I botched your email addr in the commit log.
> 
> 
> ---------- Forwarded message ----------
> From: Bjorn Helgaas <bhelgaas@google.com>
> Date: Thu, Aug 25, 2011 at 5:05 PM
> Subject: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
> To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
> <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
> Cc: RalfJungralfjung-e@gmx.de, Cyrill Gorcunov <gorcunov@openvz.org>,
> Yinghai Lu <yinghai@kernel.org>, Suresh Siddha
> <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
> 
> 
> Previously we reserved 1024 bytes, but that's more space than the IOAPIC
> consumes, and it can cause conflicts with nearby devices.  The known
> requirement is 68 bytes (sizeof(struct io_apic)), and rounding up to a
> power-of-2 gives us 128.
> 
> The bug reported below is caused by the following assignments (the IOAPIC
> power-on default and the watchdog address recommended in the AMD SP5100
> BIOS Developer's Guide):
> 
>  IOAPIC[0]        at [mem 0xfec00000-0xfec003ff]
>  SP5100 TCO timer at [mem 0xfec000f0-0xfec000f7]
> 
> Reported-by: Ralf Jung ralfjung-e@gmx.de
> Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638863
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  arch/x86/include/asm/apicdef.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apicdef.h
> b/arch/x86/include/asm/apicdef.h index 34595d5..855a18a 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -12,10 +12,11 @@
>  #define        APIC_DEFAULT_PHYS_BASE          0xfee00000
> 
>  /*
> - * This is the IO-APIC register space as specified
> - * by Intel docs:
> + * I/O APICs are accessed indirectly via an index/data pair and an EOI
> + * register.  For example, see sec 13.5.1, "APIC Register Map," in the
> + * Intel ICH10 datasheet and the struct io_apic definition.
>  */
> -#define IO_APIC_SLOT_SIZE              1024
> +#define IO_APIC_SLOT_SIZE              128
> 
>  #define        APIC_ID         0x20
