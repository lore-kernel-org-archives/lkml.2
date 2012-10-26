Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab2JZJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:32:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2JZJcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:32:16 -0400
Date: Fri, 26 Oct 2012 11:32:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: ce4100: force reboot method to be KBD
Message-ID: <20121026093211.GB1106@gmail.com>
References: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
 <1351242325-23724-3-git-send-email-ffainelli@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351242325-23724-3-git-send-email-ffainelli@freebox.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Fainelli <ffainelli@freebox.fr> wrote:

> From: Maxime Bizon <mbizon@freebox.fr>
> 
> The default reboot is via ACPI for this platform, and the CEFDK bootloader
> actually supports this, but will issue a system power off instead of a real
> reboot. Setting the reboot method to be KBD instead of ACPI ensures proper
> system reboot.
> 
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> ---
>  arch/x86/platform/ce4100/ce4100.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
> index 74f8774..8c9ed9a 100644
> --- a/arch/x86/platform/ce4100/ce4100.c
> +++ b/arch/x86/platform/ce4100/ce4100.c
> @@ -21,6 +21,7 @@
>  #include <asm/i8259.h>
>  #include <asm/io.h>
>  #include <asm/io_apic.h>
> +#include <asm/emergency-restart.h>
>  
>  static int ce4100_i8042_detect(void)
>  {
> @@ -144,6 +145,8 @@ void __init x86_ce4100_early_setup(void)
>  	x86_init.mpparse.find_smp_config = x86_init_noop;
>  	x86_init.pci.init = ce4100_pci_init;
>  
> +	reboot_type = BOOT_KBD;

Here too put a minimal comment into the code:

	/*
	 * The system default is ACPI reboot, but that powers 
	 * off on CE4100 so the use KBD reset instead:
	 */
	reboot_type = BOOT_KBD;

Thanks,

	Ingo
