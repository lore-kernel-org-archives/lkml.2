Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2ADU2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:28:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2ADU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:28:07 -0500
Date: Wed, 4 Jan 2012 12:28:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] include: crash_dump.h: Add elf.h header
Message-Id: <20120104122805.103eb7e2.akpm@linux-foundation.org>
In-Reply-To: <1325678666-13089-1-git-send-email-festevam@gmail.com>
References: <1325678666-13089-1-git-send-email-festevam@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jan 2012 10:04:26 -0200
Fabio Estevam <festevam@gmail.com> wrote:

> Building an ARM target we get the following warnings:
> 
> CC      arch/arm/kernel/setup.o
> In file included from arch/arm/kernel/setup.c:39:
> arch/arm/include/asm/elf.h:102:1: warning: "vmcore_elf64_check_arch" redefined
> In file included from arch/arm/kernel/setup.c:24:
> include/linux/crash_dump.h:30:1: warning: this is the location of the previous definition
> 
> Quoting Russell King:
> 
> "linux/crash_dump.h makes no attempt to include asm/elf.h, but it depends
> on stuff in asm/elf.h to determine how stuff inside this file is defined
> at parse time.
> 
> So, if asm/elf.h is included after linux/crash_dump.h or not at all, you
> get a different result from the situation where asm/elf.h is included
> before."
> 
> So add elf.h header to crash_dump.h to avoid this problem.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> The original discussion about this can be found at:
> http://www.spinics.net/lists/arm-kernel/msg154113.html
> 
>  include/linux/crash_dump.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> index 5c4abce..b936763 100644
> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -5,6 +5,7 @@
>  #include <linux/kexec.h>
>  #include <linux/device.h>
>  #include <linux/proc_fs.h>
> +#include <linux/elf.h>
>  
>  #define ELFCORE_ADDR_MAX	(-1ULL)
>  #define ELFCORE_ADDR_ERR	(-2ULL)

The patch is the right thing to do, however I'm rather concerned about
the potential for introducing build breakage so late in 3.2.

Can we leave this unfixed in 3.2 and fix it in 3.2.1?  Or put a
#include elf.h into arch/arm/kernel/setup.c for 3.2?

