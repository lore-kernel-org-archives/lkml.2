Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0LJV6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:58:22 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:38869 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0LJV6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:58:21 -0500
Message-ID: <4D02A275.1060308@pavlinux.ru>
Date: Sat, 11 Dec 2010 00:58:13 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 PAVLINUX/7.7.7 0xDEADBEEF/7.7.7
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Decompressors: Add boot-time XZ support
References: <fVmRb-eH-7@gated-at.bofh.it> <fYgcy-12E-3@gated-at.bofh.it>
In-Reply-To: <fYgcy-12E-3@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.12.2010 21:50, Lasse Collin wrote:
> From: Lasse Collin <lasse.collin@tukaani.org>
[--- ням ---]
>  
> +config KERNEL_XZ
> +	bool "XZ"
> +	depends on HAVE_KERNEL_XZ
> +	help
> +	  XZ uses the LZMA2 algorithm and instruction set specific
> +	  BCJ filters which can improve compression ratio of executable
> +	  code. The size of the kernel is about 30% smaller with XZ in
> +	  comparison to gzip. On architectures for which there is a BCJ
> +	  filter (i386, x86_64, ARM, IA-64, PowerPC, and SPARC), XZ
> +	  will create a few percent smaller kernel than plain LZMA.
> +
> +	  The speed is about the same as with LZMA: The decompression
> +	  speed of XZ is better than that of bzip2 but worse than gzip
> +	  and LZO. Compression is slow.
> +
>  config KERNEL_LZO
>  	bool "LZO"
>  	depends on HAVE_KERNEL_LZO

Not worked without this:

--- кусь ---

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e330da2..d27a9c7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,6 +52,7 @@ config X86
        select HAVE_KERNEL_BZIP2
        select HAVE_KERNEL_LZMA
        select HAVE_KERNEL_LZO
+       select HAVE_KERNEL_XZ
        select HAVE_HW_BREAKPOINT
        select HAVE_MIXED_BREAKPOINTS_REGS
        select PERF_EVENTS

--- кусь ---

.... and for other archs needed.
