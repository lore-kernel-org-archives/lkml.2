Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0JAJTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:19:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:35330 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0JAJTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:19:35 -0400
Subject: Re: [PATCH 01/18] powerpc: Add ability to build little endian kernels
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 1 Oct 2010 04:18:20 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Grant Likely <grant.likely@secretlab.ca>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F7E7DAE6-A132-458D-ABC3-4CC92A4C7263@kernel.crashing.org>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com> <1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
To: Ian Munsie <imunsie@au1.ibm.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2010, at 2:05 AM, Ian Munsie wrote:

> 
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index d361f81..074ff12 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -329,3 +329,19 @@ config CHECK_CACHE_COHERENCY
> 	bool
> 
> endmenu
> +
> +config ARCH_SUPPORTS_LITTLE_ENDIAN
> +	bool
> +
> +config CPU_LITTLE_ENDIAN
> +	bool "Build little endian kernel"
> +	depends on ARCH_SUPPORTS_LITTLE_ENDIAN && EXPERIMENTAL
> +	default n
> +	help
> +	  This option selects whether a big endian or little endian kernel will
> +	  be built.
> +
> +	  Note that if building a little endian kernel, CROSS_COMPILE must
> +	  point to a toolchain capable of targetting little endian powerpc,
> +	  while the toolchain specified by CROSS32_COMPILE must be capable of
> +	  targetting *BIG* endian PowerPC.
> -- 
> 1.7.1

Shouldn't we have something that limits to the sub-arch'es that actually support it?  I doubt I'm ever going to make FSL-Book-e support LE.

- k