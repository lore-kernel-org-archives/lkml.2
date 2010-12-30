Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0L3Mpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 07:45:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:38552 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761Ab0L3Mpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 07:45:42 -0500
Date: Thu, 30 Dec 2010 06:45:35 -0600
From: Robin Holt <holt@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
Message-ID: <20101230124535.GA3306@sgi.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doesn't this patch series break the 'bisectable' rule for patches?
I think you can get by with adding a CONFIG_EXPERT selects CONFIG_EMBEDDED
in the first patch and the last patch removing that same selects.

Robin

On Wed, Dec 29, 2010 at 08:02:26PM -0800, David Rientjes wrote:
> The meaning of CONFIG_EMBEDDED has long since been obsoleted; the option
> is used to configure any non-standard kernel with a much larger scope
> than only small devices.
> 
> This patch renames the option to CONFIG_EXPERT in init/Kconfig and fixes
> references to the option in the same file.  Followup patches will fix the
> remainder of the occurrences in the tree.
> 
> Calling the option "EXPERT" more accurately represents its intention:
> only expert users who understand the impact of the configuration changes
> they are making should enable it.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  init/Kconfig |   52 ++++++++++++++++++++++++++--------------------------
>  1 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -689,8 +689,8 @@ config DEBUG_BLK_CGROUP
>  endif # CGROUPS
>  
>  menuconfig NAMESPACES
> -	bool "Namespaces support" if EMBEDDED
> -	default !EMBEDDED
> +	bool "Namespaces support" if EXPERT
> +	default !EXPERT
>  	help
>  	  Provides the way to make tasks work with different objects using
>  	  the same id. For example same IPC id may refer to different objects
> @@ -830,8 +830,8 @@ config SYSCTL
>  config ANON_INODES
>  	bool
>  
> -menuconfig EMBEDDED
> -	bool "Configure standard kernel features (for small systems)"
> +menuconfig EXPERT
> +	bool "Configure standard kernel features (expert users)"
>  	help
>  	  This option allows certain base kernel options and settings
>            to be disabled or tweaked. This is for specialized
> @@ -839,14 +839,14 @@ menuconfig EMBEDDED
>            Only use this if you really know what you are doing.
>  
>  config UID16
> -	bool "Enable 16-bit UID system calls" if EMBEDDED
> +	bool "Enable 16-bit UID system calls" if EXPERT
>  	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
>  	default y
>  	help
>  	  This enables the legacy 16-bit UID syscall wrappers.
>  
>  config SYSCTL_SYSCALL
> -	bool "Sysctl syscall support" if EMBEDDED
> +	bool "Sysctl syscall support" if EXPERT
>  	depends on PROC_SYSCTL
>  	default y
>  	select SYSCTL
> @@ -863,7 +863,7 @@ config SYSCTL_SYSCALL
>  	  If unsure say Y here.
>  
>  config KALLSYMS
> -	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
> +	 bool "Load all symbols for debugging/ksymoops" if EXPERT
>  	 default y
>  	 help
>  	   Say Y here to let the kernel print out symbolic crash information and
> @@ -894,7 +894,7 @@ config KALLSYMS_EXTRA_PASS
>  
>  
>  config HOTPLUG
> -	bool "Support for hot-pluggable devices" if EMBEDDED
> +	bool "Support for hot-pluggable devices" if EXPERT
>  	default y
>  	help
>  	  This option is provided for the case where no hotplug or uevent
> @@ -904,7 +904,7 @@ config HOTPLUG
>  
>  config PRINTK
>  	default y
> -	bool "Enable support for printk" if EMBEDDED
> +	bool "Enable support for printk" if EXPERT
>  	help
>  	  This option enables normal printk support. Removing it
>  	  eliminates most of the message strings from the kernel image
> @@ -913,7 +913,7 @@ config PRINTK
>  	  strongly discouraged.
>  
>  config BUG
> -	bool "BUG() support" if EMBEDDED
> +	bool "BUG() support" if EXPERT
>  	default y
>  	help
>            Disabling this option eliminates support for BUG and WARN, reducing
> @@ -924,12 +924,12 @@ config BUG
>  
>  config ELF_CORE
>  	default y
> -	bool "Enable ELF core dumps" if EMBEDDED
> +	bool "Enable ELF core dumps" if EXPERT
>  	help
>  	  Enable support for generating core dumps. Disabling saves about 4k.
>  
>  config PCSPKR_PLATFORM
> -	bool "Enable PC-Speaker support" if EMBEDDED
> +	bool "Enable PC-Speaker support" if EXPERT
>  	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
>  	default y
>  	help
> @@ -938,14 +938,14 @@ config PCSPKR_PLATFORM
>  
>  config BASE_FULL
>  	default y
> -	bool "Enable full-sized data structures for core" if EMBEDDED
> +	bool "Enable full-sized data structures for core" if EXPERT
>  	help
>  	  Disabling this option reduces the size of miscellaneous core
>  	  kernel data structures. This saves memory on small machines,
>  	  but may reduce performance.
>  
>  config FUTEX
> -	bool "Enable futex support" if EMBEDDED
> +	bool "Enable futex support" if EXPERT
>  	default y
>  	select RT_MUTEXES
>  	help
> @@ -954,7 +954,7 @@ config FUTEX
>  	  run glibc-based applications correctly.
>  
>  config EPOLL
> -	bool "Enable eventpoll support" if EMBEDDED
> +	bool "Enable eventpoll support" if EXPERT
>  	default y
>  	select ANON_INODES
>  	help
> @@ -962,7 +962,7 @@ config EPOLL
>  	  support for epoll family of system calls.
>  
>  config SIGNALFD
> -	bool "Enable signalfd() system call" if EMBEDDED
> +	bool "Enable signalfd() system call" if EXPERT
>  	select ANON_INODES
>  	default y
>  	help
> @@ -972,7 +972,7 @@ config SIGNALFD
>  	  If unsure, say Y.
>  
>  config TIMERFD
> -	bool "Enable timerfd() system call" if EMBEDDED
> +	bool "Enable timerfd() system call" if EXPERT
>  	select ANON_INODES
>  	default y
>  	help
> @@ -982,7 +982,7 @@ config TIMERFD
>  	  If unsure, say Y.
>  
>  config EVENTFD
> -	bool "Enable eventfd() system call" if EMBEDDED
> +	bool "Enable eventfd() system call" if EXPERT
>  	select ANON_INODES
>  	default y
>  	help
> @@ -992,7 +992,7 @@ config EVENTFD
>  	  If unsure, say Y.
>  
>  config SHMEM
> -	bool "Use full shmem filesystem" if EMBEDDED
> +	bool "Use full shmem filesystem" if EXPERT
>  	default y
>  	depends on MMU
>  	help
> @@ -1003,7 +1003,7 @@ config SHMEM
>  	  which may be appropriate on small systems without swap.
>  
>  config AIO
> -	bool "Enable AIO support" if EMBEDDED
> +	bool "Enable AIO support" if EXPERT
>  	default y
>  	help
>  	  This option enables POSIX asynchronous I/O which may by used
> @@ -1080,16 +1080,16 @@ endmenu
>  
>  config VM_EVENT_COUNTERS
>  	default y
> -	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
> +	bool "Enable VM event counters for /proc/vmstat" if EXPERT
>  	help
>  	  VM event counters are needed for event counts to be shown.
>  	  This option allows the disabling of the VM event counters
> -	  on EMBEDDED systems.  /proc/vmstat will only show page counts
> +	  on EXPERT systems.  /proc/vmstat will only show page counts
>  	  if VM event counters are disabled.
>  
>  config PCI_QUIRKS
>  	default y
> -	bool "Enable PCI quirk workarounds" if EMBEDDED
> +	bool "Enable PCI quirk workarounds" if EXPERT
>  	depends on PCI
>  	help
>  	  This enables workarounds for various PCI chipset
> @@ -1098,7 +1098,7 @@ config PCI_QUIRKS
>  
>  config SLUB_DEBUG
>  	default y
> -	bool "Enable SLUB debugging support" if EMBEDDED
> +	bool "Enable SLUB debugging support" if EXPERT
>  	depends on SLUB && SYSFS
>  	help
>  	  SLUB has extensive debug support features. Disabling these can
> @@ -1142,7 +1142,7 @@ config SLUB
>  	   a slab allocator.
>  
>  config SLOB
> -	depends on EMBEDDED
> +	depends on EXPERT
>  	bool "SLOB (Simple Allocator)"
>  	help
>  	   SLOB replaces the stock allocator with a drastically simpler
> @@ -1153,7 +1153,7 @@ endchoice
>  
>  config MMAP_ALLOW_UNINITIALIZED
>  	bool "Allow mmapped anonymous memory to be uninitialized"
> -	depends on EMBEDDED && !MMU
> +	depends on EXPERT && !MMU
>  	default n
>  	help
>  	  Normally, and according to the Linux spec, anonymous memory obtained
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
