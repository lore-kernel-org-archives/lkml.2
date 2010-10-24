Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0JXKEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 06:04:16 -0400
Received: from www.tglx.de ([62.245.132.106]:37892 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0JXKEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 06:04:16 -0400
Date: Sun, 24 Oct 2010 12:03:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/15] x86, apic: Set fixmap only one time
In-Reply-To: <1287882149-29275-11-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241202580.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-11-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> Check if mp_lapic_addr is assigned or not.

Why is it called twice in the first place ? Because you messed up that
other patch ?

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/apic/apic.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 3a4e770..2cfa622 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1682,6 +1682,9 @@ void __init init_apic_mappings(void)
>  
>  void __init smp_register_lapic_address(unsigned long address)
>  {
> +	if (mp_lapic_addr)
> +		return;
> +
>  	mp_lapic_addr = address;
>  
>  	set_fixmap_nocache(FIX_APIC_BASE, address);
> -- 
> 1.7.1
> 
