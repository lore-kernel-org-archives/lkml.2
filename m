Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2KMKcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:32:42 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36517 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2KMKci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
	<CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
	<20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
Date: Tue, 13 Nov 2012 11:32:37 +0100
X-Google-Sender-Auth: P62hpceS-ChP2XkecoUMPwFIqrE
Message-ID: <CAMuHMdXu2VJhB+1uFApeBrYS3t2cfpPMaTz12F=A_FNJB1Q60w@mail.gmail.com>
Subject: Re: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 10:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 366ec06..9bc00e7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -271,6 +271,13 @@ config ARCH_WANT_OLD_COMPAT_IPC
>         select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
>         bool
>
> +config ARCH_NO_VIRT_TO_BUS
> +       bool
> +       help
> +         An architecture should select this if it cannot (or will not)
> +         implement virt_to_bus().  All new architectures should probably
> +         select this.

Don't we typically put the burden of selecting Kconfig flags for deprecated
features on the existing architectures that provide the deprecated features?

I.e. shouldn't it be ARCH_HAS_VIRT_TO_BUS, selected by the architectures
that need it, instead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
