Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab0CPVFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:05:39 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:46635 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CPVFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DDAGtRD3JkOVHFNn/Jz7KxkCYhc7/hubbmynfvZwe2YVWUfdPlwtuc8yql5DVLwi+D
         2Ns9YKnhEp2yQypIG12X7bk9986UlUdp5oOXA4CfakdCRqj5M8wMEDwz/8j/qIgYyEqf
         14sZfwO9y94l/tCo53WSbziQW4FAi7iVJv9HA=
MIME-Version: 1.0
In-Reply-To: <tip-ff30a0543e9a6cd732582063e7cae951cdb7acf2@git.kernel.org>
References: <4B9E15D30200007800034D23@vpn.id2.novell.com>
	 <tip-ff30a0543e9a6cd732582063e7cae951cdb7acf2@git.kernel.org>
Date: Tue, 16 Mar 2010 14:03:57 -0700
Message-ID: <dd18b0c31003161403r56f9fd88kcc561a630be136a3@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: Fix placement of FIX_OHCI1394_BASE
From: Justin Mattock <justinmattock@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 7:48 AM, tip-bot for Jan Beulich
<JBeulich@novell.com> wrote:
> Commit-ID:  ff30a0543e9a6cd732582063e7cae951cdb7acf2
> Gitweb:     http://git.kernel.org/tip/ff30a0543e9a6cd732582063e7cae951cdb7acf2
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Mon, 15 Mar 2010 10:11:15 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 16 Mar 2010 11:16:27 +0100
>
> x86: Fix placement of FIX_OHCI1394_BASE
>
> Ever for 32-bit with sufficiently high NR_CPUS, and starting
> with commit 789d03f584484af85dbdc64935270c8e45f36ef7 also for
> 64-bit, the statically allocated early fixmap page tables were
> not covering FIX_OHCI1394_BASE, leading to a boot time crash
> when "ohci1394_dma=early" was used. Despite this entry not being
> a permanently used one, it needs to be moved into the permanent
> range since it has to be close to FIX_DBGP_BASE and
> FIX_EARLYCON_MEM_BASE.
>
> Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com>
> Fixes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: <stable@kernel.org> # [as far back as long as it still applies]
> LKML-Reference: <4B9E15D30200007800034D23@vpn.id2.novell.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/fixmap.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 635f03b..d07b44f 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -82,6 +82,9 @@ enum fixed_addresses {
>  #endif
>        FIX_DBGP_BASE,
>        FIX_EARLYCON_MEM_BASE,
> +#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
> +       FIX_OHCI1394_BASE,
> +#endif
>  #ifdef CONFIG_X86_LOCAL_APIC
>        FIX_APIC_BASE,  /* local (CPU) APIC) -- required for SMP or not */
>  #endif
> @@ -132,9 +135,6 @@ enum fixed_addresses {
>           (__end_of_permanent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))
>         : __end_of_permanent_fixed_addresses,
>        FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
> -#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
> -       FIX_OHCI1394_BASE,
> -#endif
>  #ifdef CONFIG_X86_32
>        FIX_WP_TEST,
>  #endif
>

looks good over here..

-- 
Justin P. Mattock
