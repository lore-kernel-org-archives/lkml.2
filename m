Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1KNTPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:15:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63611 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1KNTPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:15:21 -0500
MIME-Version: 1.0
In-Reply-To: <20111108184934.5180.26968.stgit@bhelgaas.mtv.corp.google.com>
References: <20111108184934.5180.26968.stgit@bhelgaas.mtv.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 14 Nov 2011 12:14:58 -0700
Message-ID: <CAErSpo72W4ONPUEB9MmVK4xu9HN19=X19ZA_8fy=pa8wCgvEWw@mail.gmail.com>
Subject: Re: [RESEND PATCH] x86: mpparse: fix mp_bus_not_pci handling
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan McGrath <troubledaemon@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 11:49 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Dan bisected a Dell PowerEdge 4200 boot regression to commit f8924e770.
> Prior to that commit, 32-bit kernels set mp_bus_not_pci for all buses
> except PCI.  Afterwards, we set mp_bus_not_pci only for ISA.  But ISA is
> not the only non-PCI bus, so it's better to always set mp_bus_not_pci
> and clear it only for PCI.
>
> The workaround was to boot with "noapic".  Dan verified that with this
> patch, his system boots without "noapic".

We broke the poor user's system, and he went to the trouble to file a
nice bug report and even bisect it.

Can we please do him the courtesy of looking at this patch?

> Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586494
> Reported-and-tested-by: Dan McGrath <troubledaemon@gmail.com>
> Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
> Cc: stable@kernel.org # 2.6.26+
> Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  arch/x86/kernel/mpparse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index 9103b89..0741b062 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
>        }
>  #endif
>
> +       set_bit(m->busid, mp_bus_not_pci);
>        if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
> -               set_bit(m->busid, mp_bus_not_pci);
>  #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
>                mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
>  #endif
>
>
