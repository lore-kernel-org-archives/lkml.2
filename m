Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2HOQIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:08:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2HOQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:08:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 30/31] arm64: Build infrastructure
Date: Wed, 15 Aug 2012 16:07:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151607.55669.arnd@arndb.de>
X-Provags-ID: V02:K0:xnl4EUJSYkypC+N2g7wyhxqDqB/cc/RIZWYlsHw5mPe
 HEH2i0+YlU6Et0KNL9YvcPpMCQ9vbAAMRWJnV4HFZaecF6JtpR
 QBv7BP2tNHYxXPlbrXdadp4jFcoY0kguFoSCwf2DCuAKfcrPno
 SqBManA+4QD/qI538gt6QOkNeNN4Z5ywFB3dvVhk96BR9opLHm
 cK7q/VjSORZ620jHfO/YK9FovgHcqxBVpU47wH7LXN3Rj/mZBd
 uWzV5Xi+MCO/Hp49kfIDhV8qg1FDr1O58/NP+21n91FBeVafei
 vmyebF+Pgq0+qdbGSKiPKI9vSGfhrjvFj6wB0Dk4P4HTqNVdvr
 0gBgfmG80M0e9ECFB6og=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

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

Please remove HAVE_AOUT and HAVE_IDE

> +	select HAVE_MEMBLOCK
> +	select RTC_LIB
> +	select SYS_SUPPORTS_APM_EMULATION

APM_EMULATION can probably go too

> +
> +config ARCH_PHYS_ADDR_T_64BIT
> +	def_bool y
> +
> +config HAVE_PWM
> +	bool

HAVE_PWM is going away soon.

> +config AARCH32_EMULATION
> +	bool "Kernel support for 32-bit EL0"
> +	depends on !ARM64_64K_PAGES
> +	select COMPAT_BINFMT_ELF
> +	help
> +	  This option enables support for a 32-bit EL0 running under a 64-bit
> +	  kernel at EL1. AArch32-specific components such as system calls,
> +	  the user helper functions, VFP support and the ptrace interface are
> +	  handled appropriately by the kernel.
> +
> +	  If you want to execute 32-bit userspace applications, say Y.
> +
> +config COMPAT
> +	def_bool y
> +	depends on AARCH32_EMULATION

As mentioned, you can just merge the two into CONFIG_COMPAT.

> +targets := Image Image.gz
> +
> +$(obj)/Image: vmlinux FORCE
> +	$(call if_changed,objcopy)
> +	@echo '  Kernel: $@ is ready'
> +
> +$(obj)/Image.gz: $(obj)/Image FORCE
> +	$(call if_changed,gzip)
> +	@echo '  Kernel: $@ is ready'

Drop the useless output, at least when building with make -s.

> +if [ -x /sbin/loadmap ]; then
> +  /sbin/loadmap
> +else
> +  echo "You have to install it yourself"
> +fi

What is loadmap?

> diff --git a/arch/arm64/configs/generic_defconfig b/arch/arm64/configs/generic_defconfig
> new file mode 100644
> index 0000000..d9aac95
> --- /dev/null
> +++ b/arch/arm64/configs/generic_defconfig

I think it can just be called "defconfig".

> diff --git a/arch/arm64/mm/Kconfig b/arch/arm64/mm/Kconfig
> new file mode 100644
> index 0000000..8e94e52
> --- /dev/null
> +++ b/arch/arm64/mm/Kconfig
> @@ -0,0 +1,5 @@
> +config MMU
> +	def_bool y
> +
> +config CPU_64
> +	def_bool y

This file can be dropped. You can unconditionally enable CONFIG_MMU,
and the CPU_64 symbol is pointless, just use CONFIG_64BIT.

	Arnd
