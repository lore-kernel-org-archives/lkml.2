Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1AXTul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:50:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61384 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1AXTuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jPNBWwxFoGJgwqcE3x+tx282uGpFfNHiFWeuVr+CYNRwo/JRZwpTAgzAu3WQ7x/9hA
         QU3RpCQpe0l0rWeyyq0b8KU1plkeRmBtK1EuYi3Ck2YPF7EGfsaREXQ/hdBqKtX/vigC
         Z5EVNkVeRcsH4e2yApJ9nyiwYBZhROiFYEHao=
MIME-Version: 1.0
In-Reply-To: <1295789862-25482-2-git-send-email-tj@kernel.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
	<1295789862-25482-2-git-send-email-tj@kernel.org>
Date: Mon, 24 Jan 2011 11:50:39 -0800
X-Google-Sender-Auth: fymmbvfR6RevEx2lQCCgi4pM6lo
Message-ID: <AANLkTimPZUzhMB08ikJ_uZLk9iteJ6PdgvbGq9yWa2vO@mail.gmail.com>
Subject: Re: [PATCH 01/16] x86: Kill unused static boot_cpu_logical_apicid in smpboot.c
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, eric.dumazet@gmail.com,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org,
        shaohui.zheng@intel.com, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 5:37 AM, Tejun Heo <tj@kernel.org> wrote:
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> ---
>  arch/x86/kernel/smpboot.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 763df77..c255980 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -165,8 +165,6 @@ static void unmap_cpu_to_node(int cpu)
>  #endif
>
>  #ifdef CONFIG_X86_32
> -static int boot_cpu_logical_apicid;
> -
>  u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
>                                        { [0 ... NR_CPUS-1] = BAD_APICID };
>
> @@ -1096,9 +1094,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>         * Setup boot CPU information
>         */
>        smp_store_cpu_info(0); /* Final full version of the data */
> -#ifdef CONFIG_X86_32
> -       boot_cpu_logical_apicid = logical_smp_processor_id();
> -#endif
> +
>        current_thread_info()->cpu = 0;  /* needed? */
>        for_each_possible_cpu(i) {
>                zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);

Acked-by: Yinghai Lu <yinghai@kernel.org>
