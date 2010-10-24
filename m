Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0JXJug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:50:36 -0400
Received: from www.tglx.de ([62.245.132.106]:36244 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0JXJuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:50:35 -0400
Date: Sun, 24 Oct 2010 11:49:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] x86, apic: Merge two register_lapic_address()
In-Reply-To: <1287882149-29275-4-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241149110.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-4-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> They are the same, move it to apic.c
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/apic.h |    1 +
>  arch/x86/kernel/acpi/boot.c |   16 ++--------------
>  arch/x86/kernel/apic/apic.c |   12 ++++++++++++
>  arch/x86/kernel/mpparse.c   |   12 ------------
>  4 files changed, 15 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index ad50aaa..dcc5f48 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -234,6 +234,7 @@ extern void init_bsp_APIC(void);
>  extern void setup_local_APIC(void);
>  extern void end_local_APIC_setup(void);
>  extern void init_apic_mappings(void);
> +void smp_register_lapic_address(unsigned long address);

And why must this be restricted to smp ? 

Thanks,

	tglx
