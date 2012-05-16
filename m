Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2EPPF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:05:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59799 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2EPPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:05:55 -0400
Date: Wed, 16 May 2012 08:05:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 4/6] staging: android: persistent_ram: Move to
 fs/pstore/ram_core.c
Message-ID: <20120516150550.GA22945@kroah.com>
References: <20120516124109.GA14658@lizard>
 <20120516124338.GD18345@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516124338.GD18345@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 05:43:38AM -0700, Anton Vorontsov wrote:
> This is a first step for adding ECC support for pstore RAM backend: we
> will use the persistent_ram routines, kindly provided by Google.
> 
> Basically, persistent_ram is a set of helper routines to deal with the
> [optionally] ECC-protected persistent ram regions.
> 
> A bit of Makefile, Kconfig and header files adjustments were needed
> because of the move.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Acked-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/staging/android/Kconfig          |   10 +-
>  drivers/staging/android/Makefile         |    1 -
>  drivers/staging/android/persistent_ram.c |  532 ------------------------------
>  drivers/staging/android/persistent_ram.h |   82 -----
>  drivers/staging/android/ram_console.c    |    2 +-
>  fs/pstore/Kconfig                        |    7 +-
>  fs/pstore/Makefile                       |    2 +-
>  fs/pstore/ram_core.c                     |  532 ++++++++++++++++++++++++++++++
>  include/linux/pstore_ram.h               |   80 +++++
>  9 files changed, 620 insertions(+), 628 deletions(-)
>  delete mode 100644 drivers/staging/android/persistent_ram.c
>  delete mode 100644 drivers/staging/android/persistent_ram.h
>  create mode 100644 fs/pstore/ram_core.c

After applying this patch, and building things, I get the following
errors:

drivers/built-in.o: In function `ram_console_write':
ram_console.c:(.text+0x1690b9): undefined reference to `persistent_ram_write'
drivers/built-in.o: In function `ram_console_read_old':
ram_console.c:(.text+0x1690f7): undefined reference to `persistent_ram_old_size'
ram_console.c:(.text+0x169103): undefined reference to `persistent_ram_old'
ram_console.c:(.text+0x169136): undefined reference to `persistent_ram_ecc_string'
ram_console.c:(.text+0x169177): undefined reference to `persistent_ram_ecc_string'
drivers/built-in.o: In function `ram_console_probe':
ram_console.c:(.init.text+0xc9ea): undefined reference to `persistent_ram_init_ringbuffer'
drivers/built-in.o: In function `ram_console_late_init':
ram_console.c:(.init.text+0xca6c): undefined reference to `persistent_ram_old_size'
ram_console.c:(.init.text+0xcaa2): undefined reference to `persistent_ram_free_old'
ram_console.c:(.init.text+0xcab4): undefined reference to `persistent_ram_old_size'
ram_console.c:(.init.text+0xcac3): undefined reference to `persistent_ram_ecc_string'
make: *** [.tmp_vmlinux1] Error 1

What went wrong?

I've now applied the first 3 patches in this series to my tree, plus the
2 others from the linux-next tree, so care to just fix up these last
three and resend them?

thanks,

greg k-h
