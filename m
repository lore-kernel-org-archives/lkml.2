Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab0F2HeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:34:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37617 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0F2HeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100628220048.6a07c5ee@debian>
References: <20100628215407.2017bf2f@debian> <20100628220048.6a07c5ee@debian>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 29 Jun 2010 00:33:59 -0700
X-Google-Sender-Auth: 5oo4Cb6o1whTvWx6312__FRnjAg
Message-ID: <AANLkTil30jVU79NGdPdAw516-_AOTzbX6DQdwahv4evx@mail.gmail.com>
Subject: Re: [PATCH 3/4] proc: unify PROC_DEVICETREE config
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 7:00 PM, Andres Salomon <dilinger@queued.net> wrote:
>
> Microblaze and PPC both use PROC_DEVICETREE, and OLPC will as well.. put
> the Kconfig option into fs/ rather than in arch/*/Kconfig.
>
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  arch/microblaze/Kconfig |    8 --------
>  arch/powerpc/Kconfig    |    8 --------
>  fs/proc/Kconfig         |    8 ++++++++
>  3 files changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 76818f9..b66c962 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -128,14 +128,6 @@ config OF
>        def_bool y
>        select OF_FLATTREE
>
> -config PROC_DEVICETREE
> -       bool "Support for device tree in /proc"
> -       depends on PROC_FS
> -       help
> -         This option adds a device-tree directory under /proc which contains
> -         an image of the device tree that the kernel copies from Open
> -         Firmware or other boot firmware. If unsure, say Y here.
> -
>  endmenu
>
>  menu "Advanced setup"
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 328774b..8a56e8b 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -578,14 +578,6 @@ config SCHED_SMT
>          when dealing with POWER5 cpus at a cost of slightly increased
>          overhead in some places. If unsure say N here.
>
> -config PROC_DEVICETREE
> -       bool "Support for device tree in /proc"
> -       depends on PROC_FS
> -       help
> -         This option adds a device-tree directory under /proc which contains
> -         an image of the device tree that the kernel copies from Open
> -         Firmware or other boot firmware. If unsure, say Y here.
> -
>  config CMDLINE_BOOL
>        bool "Default bootloader kernel arguments"
>
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 50f8f06..858a859 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -39,6 +39,14 @@ config PROC_VMCORE
>         help
>         Exports the dump image of crashed kernel in ELF format.
>
> +config PROC_DEVICETREE
> +       bool "Support for device tree in /proc"
> +       depends on PROC_FS && (PPC || MICROBLAZE)
> +       help
> +         This option adds a device-tree directory under /proc which contains
> +         an image of the device tree that the kernel copies from Open
> +         Firmware or other boot firmware. If unsure, say Y here.
> +

Looks good to me.  However, I've changed the depends line to the following.

depends on PROC_FS && OF && !SPARC

Cheers,
g.
