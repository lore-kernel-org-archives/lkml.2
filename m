Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2FASWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:22:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46098 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab2FASWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:22:03 -0400
MIME-Version: 1.0
In-Reply-To: <1338562358-28182-3-git-send-email-bp@amd64.org>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
	<1338562358-28182-3-git-send-email-bp@amd64.org>
Date: Fri, 1 Jun 2012 11:22:03 -0700
X-Google-Sender-Auth: ZBURQ1DsHC01THpXl3G8nu2xPgI
Message-ID: <CAE9FiQVad9qWvZeBej31Mw4aEJO3L0L6ZC7mx7VJQwRB_q8fzQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86, CPU: Fix show_msr MSR accessing function
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 7:52 AM, Borislav Petkov <bp@amd64.org> wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> There's no real reason why, when showing the MSRs on a CPU at boottime,
> we should be using the AMD-specific variant. Simply use the generic safe
> one which handles #GPs just fine.
>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 82f29e70d058..232fba2d54c9 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -947,7 +947,7 @@ static void __cpuinit __print_cpu_msr(void)
>                index_max = msr_range_array[i].max;
>
>                for (index = index_min; index < index_max; index++) {
> -                       if (rdmsrl_amd_safe(index, &val))
> +                       if (rdmsrl_safe(index, &val))
>                                continue;
>                        printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
>                }
> --

can you double check if the range will need special passcode ?



        { 0x00000000, 0x00000418},
        { 0xc0000000, 0xc000040b},
        { 0xc0010000, 0xc0010142},
        { 0xc0011000, 0xc001103b},

passcode should be
       gprs[7] = 0x9c5a203a;

Thanks

Yinghai
