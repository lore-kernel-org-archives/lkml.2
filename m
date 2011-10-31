Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1JaREh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:04:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab1JaREg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:04:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eB4OooZznmnxL+BXrrPll46F708cq0ZWYZT61t54t/V0mDaK+tcwco1sNmpPbzb3w
	CoQUiWZKaNxJCGHuRiyAw==
MIME-Version: 1.0
In-Reply-To: <20111018144747.17121.82799.stgit@bhelgaas.mtv.corp.google.com>
References: <20111018144747.17121.82799.stgit@bhelgaas.mtv.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 31 Oct 2011 11:04:11 -0600
Message-ID: <CAErSpo40=2Gp-8OyOZ6BBCWEdFkgr7OJ8DxE7YfYjSpNoDj0iA@mail.gmail.com>
Subject: Re: [PATCH] x86: mpparse: fix mp_bus_not_pci handling
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan McGrath <troubledaemon@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 8:47 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Dan bisected a Dell PowerEdge 4200 boot regression to commit f8924e770.
> Prior to that commit, 32-bit kernels set mp_bus_not_pci for all buses
> except PCI.  Afterwards, we set mp_bus_not_pci only for ISA.  But ISA is
> not the only non-PCI bus, so it's better to always set mp_bus_not_pci
> and clear it only for PCI.
>
> The workaround was to boot with "noapic".  Dan verified that with this
> patch, his system boots without "noapic".
>
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

Ping?
