Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2L1WP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:15:27 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:48690 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2L1WPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:15:25 -0500
MIME-Version: 1.0
In-Reply-To: <20120814151704.GA17668@localhost>
References: <20120814151704.GA17668@localhost>
Date: Fri, 28 Dec 2012 23:15:23 +0100
X-Google-Sender-Auth: vw6v2VwtZbjpsBtnZ6_svMFi6aM
Message-ID: <CAMuHMdU4aa0qLJVR1X=eKMN6TTuuE3JqVrCVSXrMB3AEpgcf1g@mail.gmail.com>
Subject: Re: [PATCH] mn10300: select generic atomic64_t support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:17 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Rationals from Eric:
>
> So I just looked a little deeper and it appears architectures that do
> not support atomic64_t are broken.
>
> The generic atomic64 support came in 2009 to support the perf subsystem
> with the expectation that all architectures would implement atomic64
> support.
>
> Furthermore upon inspection of the kernel atomic64_t is used in a fair
> number of places beyond the performance counters:
>
> block/blk-cgroup.c
> drivers/acpi/apei/
> drivers/block/rbd.c
> drivers/crypto/nx/nx.h
> drivers/gpu/drm/radeon/radeon.h
> drivers/infiniband/hw/ipath/
> drivers/infiniband/hw/qib/
> drivers/staging/octeon/
> fs/xfs/
> include/linux/perf_event.h
> include/net/netfilter/nf_conntrack_acct.h
> kernel/events/
> kernel/trace/
> net/mac80211/key.h
> net/rds/
>
> The block control group, infiniband, xfs, crypto, 802.11, netfilter.
> Nothing quite so fundamental as fs/namespace.c but definitely in
> multiplatform-code that should work, and is already broken on those
> architecutres.
>
> Looking at the implementation of atomic64_add_return in lib/atomic64.c
> the code looks as efficient as these kinds of things get.
>
> Which leads me to the conclusion that we need atomic64 support on all
> architectures.
>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  arch/mn10300/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux.orig/arch/mn10300/Kconfig     2012-08-03 15:36:21.391560778 +0800
> +++ linux/arch/mn10300/Kconfig  2012-08-14 22:53:14.751795832 +0800
> @@ -8,6 +8,7 @@ config MN10300
>         select HAVE_ARCH_KGDB
>         select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
>         select GENERIC_CLOCKEVENTS
> +       select GENERIC_ATOMIC64
>
>  config AM33_2
>         def_bool n

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
