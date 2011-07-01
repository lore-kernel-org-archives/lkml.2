Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1GAXPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:15:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55845 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab1GAXPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <201107020005.02075.arnd@arndb.de>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg> <201107020005.02075.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 1 Jul 2011 19:15:16 -0400
Message-ID: <CAMjpGUcrZpqDwi8r+BmyDV29-FcU9miJLv-dHGjUYY_GLYLU8A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc5
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 18:05, Arnd Bergmann wrote:
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -21,7 +21,7 @@
>  #include <linux/pfn.h>
>  #include <asm/io.h>
>
> -
> +#ifdef IO_SPACE_LIMIT
>  struct resource ioport_resource = {
>        .name   = "PCI IO",
>        .start  = 0,
> @@ -29,6 +29,7 @@ struct resource ioport_resource = {
>        .flags  = IORESOURCE_IO,
>  };
>  EXPORT_SYMBOL(ioport_resource);
> +#endif

hmm, asm-generic/io.h unconditionally sets this to 0xffff.  should
that depend on CONFIG_HAS_IOPORT ?
-mike
