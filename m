Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0LJWWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:22:35 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:27901 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0LJWWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:22:34 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: pavel@pavlinux.ru
Subject: Re: [PATCH v3] Decompressors: Add boot-time XZ support
Date: Sat, 11 Dec 2010 00:23:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-ARCH; KDE/4.5.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <fVmRb-eH-7@gated-at.bofh.it> <fYgcy-12E-3@gated-at.bofh.it> <4D02A275.1060308@pavlinux.ru>
In-Reply-To: <4D02A275.1060308@pavlinux.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012110023.16771.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-10 Pavel Vasilyev wrote:
> On 10.12.2010 21:50, Lasse Collin wrote:
> > From: Lasse Collin <lasse.collin@tukaani.org>
> 
> [--- ням ---]
> 
> > +config KERNEL_XZ
> > +	bool "XZ"
> > +	depends on HAVE_KERNEL_XZ
> > +	help
> > +	  XZ uses the LZMA2 algorithm and instruction set specific
> > +	  BCJ filters which can improve compression ratio of executable
> > +	  code. The size of the kernel is about 30% smaller with XZ in
> > +	  comparison to gzip. On architectures for which there is a BCJ
> > +	  filter (i386, x86_64, ARM, IA-64, PowerPC, and SPARC), XZ
> > +	  will create a few percent smaller kernel than plain LZMA.
> > +
> > +	  The speed is about the same as with LZMA: The decompression
> > +	  speed of XZ is better than that of bzip2 but worse than gzip
> > +	  and LZO. Compression is slow.
> > +
> > 
> >  config KERNEL_LZO
> >  
> >  	bool "LZO"
> >  	depends on HAVE_KERNEL_LZO
> 
> Not worked without this:
> 
> --- кусь ---
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e330da2..d27a9c7 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -52,6 +52,7 @@ config X86
>         select HAVE_KERNEL_BZIP2
>         select HAVE_KERNEL_LZMA
>         select HAVE_KERNEL_LZO
> +       select HAVE_KERNEL_XZ
>         select HAVE_HW_BREAKPOINT
>         select HAVE_MIXED_BREAKPOINTS_REGS
>         select PERF_EVENTS
> 
> --- кусь ---
> 
> .... and for other archs needed.

Support for XZ-compressed kernel on x86 is in a separate patch:

    http://lkml.org/lkml/2010/12/2/236

I hope other people will do similar patches for other archs later.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
