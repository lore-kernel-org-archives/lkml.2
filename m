Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2LUEKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:10:08 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43866 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUEKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <1356032893-2730-10-git-send-email-fenghua.yu@intel.com>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
	<1356032893-2730-10-git-send-email-fenghua.yu@intel.com>
Date: Thu, 20 Dec 2012 20:09:58 -0800
X-Google-Sender-Auth: Id8rsJh-T4NrSeKccmmliKXHL-Y
Message-ID: <CAE9FiQUCqeWH2qezRMH=PY39tiy4MhSF1yy77QUBfdtPMr_hqQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
From: Yinghai Lu <yinghai@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:48 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>
> This updates ucode on BSP in 64-bit mode. Paging and virtual address are
> working now.
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/head64.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index e1cb611..1ccbaf1 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -26,6 +26,7 @@
>  #include <asm/kdebug.h>
>  #include <asm/e820.h>
>  #include <asm/bios_ebda.h>
> +#include <asm/microcode.h>
>
>  /*
>   * Manage page tables very early on.
> @@ -179,6 +180,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
>         }
>         load_idt((const struct desc_ptr *)&idt_descr);
>
> +       /*
> +        * Load microcode early on BSP.
> +        */
> +       load_ucode_bsp(__va(real_mode_data));
> +
>         copy_bootdata(__va(real_mode_data));

can you make load_ucode_bsp take boot_param directly instead of
real_mode_data. ?

could be


        copy_bootdata(__va(real_mode_data));
+
+        /* Load microcode early on BSP. */
+       load_ucode_bsp(&boot_params);
+

because copy_bootdata, already copy boot_params...

Thanks

Yinghai
