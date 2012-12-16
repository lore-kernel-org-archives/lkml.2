Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2LPR7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:59:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64094 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2LPR7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:59:02 -0500
MIME-Version: 1.0
In-Reply-To: <1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
Date: Sun, 16 Dec 2012 09:59:01 -0800
X-Google-Sender-Auth: puXwE8xRrjXhCy5prq0AbTuSTXY
Message-ID: <CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
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

On Sun, Dec 16, 2012 at 2:43 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>
> This updates ucode in 64-bit mode. Paging and virtual address are working now.
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/head64.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 037df57..a512f56 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -25,6 +25,7 @@
>  #include <asm/kdebug.h>
>  #include <asm/e820.h>
>  #include <asm/bios_ebda.h>
> +#include <asm/microcode.h>
>
>  static void __init zap_identity_mappings(void)
>  {
> @@ -73,6 +74,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
>         /* clear bss before set_intr_gate with early_idt_handler */
>         clear_bss();
>
> +       /*
> +        * Load microcode early on BSP.
> +        */
> +       load_ucode_bsp(real_mode_data);
> +
>         /* Make NULL pointers segfault */
>         zap_identity_mappings();
>

So this patchset is after #PF handler set early page table version?

then load_ucode_bsp() should be after

   load_idt((const struct desc_ptr *)&idt_descr);

otherwise it will not work.

Yinghai
