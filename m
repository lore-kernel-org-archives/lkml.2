Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0LIQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:41:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41858 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0LIQlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:39 -0500
Date: Thu, 9 Dec 2010 08:41:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Cc: "Arnd Bergmann" <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 003/211] unicore32: new file
 arch/unicore32/Kconfig.debug
Message-Id: <20101209084118.2587060b.randy.dunlap@oracle.com>
In-Reply-To: <01d001cb9784$07a80440$16f80cc0$@mprc.pku.edu.cn>
References: <01d001cb9784$07a80440$16f80cc0$@mprc.pku.edu.cn>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010 17:32:42 +0800 Guan Xuetao wrote:

> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> 	Kconfig file for debugger
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/Kconfig.debug |   86
> ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 86 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
> new file mode 100644
> index 0000000..e59ab3c
> --- /dev/null
> +++ b/arch/unicore32/Kconfig.debug
> @@ -0,0 +1,86 @@
> +menu "Kernel hacking"
> +
> +source "lib/Kconfig.debug"
> +
> +config STRICT_DEVMEM
> +	bool "Filter access to /dev/mem"
> +	depends on MMU
> +	---help---
> +	  If this option is disabled, you allow userspace (root) access to
> all

Your mail app (or some messed-up server) is splitting long lines.  This
makes the patch file invalid -- it cannot be applied cleanly.


> +	  of memory, including kernel and userspace memory. Accidental
> +	  access to this is obviously disastrous, but specific access can
> +	  be used by people debugging the kernel.
> +
> +	  If this option is switched on, the /dev/mem file only allows
> +	  userspace access to memory mapped peripherals.
> +
> +          If in doubt, say Y.
> +
> +config EARLY_PRINTK
> +	bool "Early printk"
> +	default DEBUG_OCD
> +	help
> +	  Write kernel log output directly into the ocd or to a serial port.
> +
> +	  This is useful for kernel debugging when your machine crashes very
> +	  early before the console code is initialized. For normal operation
> +	  it is not recommended because it looks ugly and doesn't cooperate
> +	  with klogd/syslogd or the X server. You should normally N here,
> +	  unless you want to debug such a crash.
> +
> +config DEBUG_USER
> +	bool "Verbose user fault messages"
> +	help
> +	  When a user program crashes due to an exception, the kernel can
> +	  print a brief message explaining what the problem was. This is
> +	  sometimes helpful for debugging but serves no purpose on a
> +	  production system. Most people should say N here.
> +
> +	  In addition, you need to pass user_debug=N on the kernel command
> +	  line to enable this feature.  N consists of the sum of:
> +
> +	      1 - undefined instruction events
> +	      2 - system calls
> +	      4 - invalid data aborts
> +	      8 - SIGSEGV faults
> +	     16 - SIGBUS faults
> +
> +config DEBUG_STACK_USAGE
> +	bool "Enable stack utilization instrumentation"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Enables the display of the minimum amount of free stack which each
> +	  task has ever had available in the sysrq-T output.
> +
> +# These options are only for real kernel hackers who want to get their
> hands dirty.

Same thing here (above).


> +config DEBUG_LL
> +	bool "Kernel low-level debugging functions"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Say Y here to include definitions of printascii, printch, printhex
> +	  in the kernel.  This is helpful if you are debugging code that
> +	  executes before the console is initialized.
> +
> +config DEBUG_OCD
> +	bool "Kernel low-level debugging via On-Chip-Debugger"
> +	depends on DEBUG_LL
> +	default y
> +	help
> +	  Say Y here if you want the debug print routines to direct their
> +	  output to the UniCore On-Chip-Debugger channel using CP #1.
> +
> +config DEBUG_OCD_BREAKPOINT
> +	bool "Breakpoint support via On-Chip-Debugger"
> +	depends on DEBUG_OCD
> +
> +config DEBUG_UART
> +	int "Kernel low-level debugging messages via serial port"
> +	depends on DEBUG_LL
> +	range 0 1
> +	default "0"
> +	help
> +	  Choice for UART for kernel low-level using PKUnity UARTS,
> +	  should be between zero and one. The port must have been
> +	  initialised by the boot-loader before use.
> +
> +endmenu
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
