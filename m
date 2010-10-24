Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0JXJyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:54:13 -0400
Received: from www.tglx.de ([62.245.132.106]:36285 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0JXJyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:54:12 -0400
Date: Sun, 24 Oct 2010 11:53:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] x86, apic: Remove early_init_lapic_mapping
In-Reply-To: <1287882149-29275-5-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241150340.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-5-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> It is almost the same as smp_register_lapic_addr()
> 
> Just need to make smp_read_mpc() call smp_register_lapic_addr when early==1.

> @@ -289,17 +289,13 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
>  #ifdef CONFIG_X86_32
>  	generic_mps_oem_check(mpc, oem, str);
>  #endif
> -	/* save the local APIC address, it might be non-default */
> +	/* Initialize the lapic mapping */
>  	if (!acpi_lapic)
> -		mp_lapic_addr = mpc->lapic;
> +		smp_register_lapic_address(mpc->lapic);

How is this restricted to early == 1 ? It's called unconditionally
which is nonsense.

Thanks,

	tglx
