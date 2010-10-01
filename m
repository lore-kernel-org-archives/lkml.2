Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0JALkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:40:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50134 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab0JALkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fzysdbkNfhiYly0Jq1OPr+pFXYv4QJe3p96elHp23QsUhrO0StVUqHhOLzXf3xHnNL
         zhdJsV2A0q0DAPlvx3rwEJ5rg/9dLOiWBEM2HNuihDa9DV40gBi66+S9VJbm4SOd1wXI
         omXYk/3/JkLjqQkI4VCnzydNkLaPB2XfzpUQI=
MIME-Version: 1.0
In-Reply-To: <1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 1 Oct 2010 07:40:49 -0400
Message-ID: <AANLkTimdV2FTEhcKXcM_+k23PBFTR5KvyjqEGxzzX72Q@mail.gmail.com>
Subject: Re: [PATCH 01/18] powerpc: Add ability to build little endian kernels
From: Josh Boyer <jwboyer@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, Michal Marek <mmarek@suse.cz>,
        Albert Herranz <albert_herranz@yahoo.es>, paulus@samba.org,
        Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 3:05 AM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index d361f81..074ff12 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -329,3 +329,19 @@ config CHECK_CACHE_COHERENCY
>        bool
>
>  endmenu
> +
> +config ARCH_SUPPORTS_LITTLE_ENDIAN
> +       bool
> +
> +config CPU_LITTLE_ENDIAN
> +       bool "Build little endian kernel"
> +       depends on ARCH_SUPPORTS_LITTLE_ENDIAN && EXPERIMENTAL
> +       default n
> +       help
> +         This option selects whether a big endian or little endian kernel will
> +         be built.
> +
> +         Note that if building a little endian kernel, CROSS_COMPILE must
> +         point to a toolchain capable of targetting little endian powerpc,
> +         while the toolchain specified by CROSS32_COMPILE must be capable of
> +         targetting *BIG* endian PowerPC.

Have you tested this support with a userspace containing floating
point instructions?  I wonder if CONFIG_MATH_EMULATION is going to
need work at all, and if the boards with an actual FPU (440EP, 440EPx,
460EX, etc) would have issues.

josh
