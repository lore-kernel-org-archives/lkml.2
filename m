Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2HNVBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:01:08 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:26973 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab2HNVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:01:05 -0400
Date: Tue, 14 Aug 2012 23:01:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 30/31] arm64: Build infrastructure
Message-ID: <20120814210102.GA4386@merkur.ravnborg.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> new file mode 100644
> index 0000000..1ce3d04
> --- /dev/null
> +++ b/arch/arm64/Kconfig
> @@ -0,0 +1,261 @@
> +config ARM64
> +	def_bool y
> +	select OF
> +	select OF_EARLY_FLATTREE
> +	select IRQ_DOMAIN
> +	select HAVE_AOUT
> +	select HAVE_DMA_ATTRS
> +	select HAVE_DMA_API_DEBUG
> +	select HAVE_IDE
> +	select HAVE_MEMBLOCK
> +	select RTC_LIB
> +	select SYS_SUPPORTS_APM_EMULATION
> +	select HAVE_GENERIC_DMA_COHERENT
> +	select GENERIC_IOMAP
> +	select HAVE_IRQ_WORK
> +	select HAVE_PERF_EVENTS
> +	select HAVE_ARCH_TRACEHOOK
> +	select PERF_USE_VMALLOC
> +	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> +	select HAVE_GENERIC_HARDIRQS
> +	select GENERIC_HARDIRQS_NO_DEPRECATED
> +	select HAVE_SPARSE_IRQ
> +	select SPARSE_IRQ
> +	select GENERIC_IRQ_SHOW
> +	select GENERIC_SMP_IDLE_THREAD
> +	select NO_BOOTMEM

If you keep this list sorted then merge conflicts are less likely.


> +	help
> +	  ARM 64-bit (AArch64) Linux support.
> +
> +config 64BIT
> +	def_bool y
> +
> +config ARCH_PHYS_ADDR_T_64BIT
> +	def_bool y
> +
> +config HAVE_PWM
> +	bool
> +
> +config SYS_SUPPORTS_APM_EMULATION
> +	bool
> +
> +config NO_IOPORT
> +	def_bool y
> +
> +config GENERIC_GPIO
> +	bool
> +
> +config GENERIC_TIME_VSYSCALL
> +	def_bool y
Please use select like all other archs do.


> +
> +config GENERIC_CLOCKEVENTS
> +	def_bool y
Again - please use select.

> +
> +config STACKTRACE_SUPPORT
> +	def_bool y
> +
> +config LOCKDEP_SUPPORT
> +	def_bool y
> +
> +config TRACE_IRQFLAGS_SUPPORT
> +	def_bool y
> +
> +config HARDIRQS_SW_RESEND
> +	def_bool y
Please use select.

> +
> +config GENERIC_IRQ_PROBE
> +	def_bool y
Please use select.

> +
> +config GENERIC_LOCKBREAK
> +	def_bool y
> +	depends on SMP && PREEMPT
> +
> +config RWSEM_GENERIC_SPINLOCK
> +	def_bool y
> +
> +config RWSEM_XCHGADD_ALGORITHM
> +	bool
> +
> +config ARCH_HAS_ILOG2_U32
> +	bool
> +
> +config ARCH_HAS_ILOG2_U64
> +	bool
> +
> +config ARCH_HAS_CPUFREQ
> +	bool
> +	help
> +	  Internal node to signify that the ARCH has CPUFREQ support
> +	  and that the relevant menu configurations are displayed for
> +	  it.
> +
> +config GENERIC_HWEIGHT
> +	def_bool y
> +
> +config GENERIC_CSUM
> +        def_bool y
> +
> +config GENERIC_CALIBRATE_DELAY
> +	def_bool y
> +
> +config ZONE_DMA32
> +	def_bool y
> +
> +config ARCH_DMA_ADDR_T_64BIT
> +	def_bool y
> +
> +config NEED_DMA_MAP_STATE
> +	def_bool y
> +
> +config NEED_SG_DMA_LENGTH
> +	def_bool y
> +
> +config SWIOTLB
> +	def_bool y
> +
> +config IOMMU_HELPER
> +	def_bool SWIOTLB
> +


	Sam
