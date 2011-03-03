Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab1CCVSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:18:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44315 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1CCVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:18:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xAqCtvYL9ovOJVIwHJdCyxKQaFfO95vB51IowIFcD1WuQJFiLzqxPAXNqOPjTasIBe
         A74uo3mCyidrgqeWFCKAoEK/po7RhkufBjWwshQxQ1vDAxu06t1kLwC7sOh3R8Asx3gU
         1gEL5YWrBZgrSzUt/wF7Nx+9d3oPuziDfDYDI=
Message-ID: <4D7005B1.4020008@gmail.com>
Date: Fri, 04 Mar 2011 00:18:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: fix section of a disable_apic_timer
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-7-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1299182701-8591-7-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:05 PM, Henrik Kretzschmar wrote:
> This variable placed better into section .init.data,
> since its only accessed by __init code.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
>  arch/x86/kernel/apic/apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 64efb2d..dab58b6 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -163,7 +163,7 @@ early_param("nox2apic", setup_nox2apic);
>  unsigned long mp_lapic_addr;
>  int disable_apic;
>  /* Disable local APIC timer from the kernel commandline or via dmi quirk */
> -static int disable_apic_timer __cpuinitdata;
> +static int disable_apic_timer __initdata = 0;
>  /* Local APIC timer works in C2 */
>  int local_apic_timer_c2_ok;
>  EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);

Good to me, though I don't get why we need 0 here.

-- 
    Cyrill
